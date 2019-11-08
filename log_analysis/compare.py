import sys
import os

def load_data(my_file):
    data = {}
    # map cookie to segments in dictionary
    with open(my_file, 'r') as file_obj:
        for line in file_obj:
            if 'evaluated' not in line:
                continue
            relevant = line.split('evaluated: ')[1]
            if not relevant:
                raise ValueError('error parsing cookie and segments for line: %s' % line)
            cookie, segments = relevant.split(' ==> ')
            if cookie in data:
                raise KeyError('cookie already exists in keys for cookie: %s' % cookie)
            segments = segments.strip('[]\n')
            segments = segments.split(', ') if segments else []
            data[cookie] = segments
    return data

def main():
    # open and read both log files
    if len(sys.argv) < 3:
        raise RuntimeError('User must provide two filenames: baseline file and file to compare.')
    if not os.path.isfile(sys.argv[1]):
        raise RuntimeError('The provided baseline file does not exist: %s' % sys.argv[1])
    if not os.path.isfile(sys.argv[2]):
        raise RuntimeError('The provided comparison file does not exist: %s' % sys.argv[2])
    baseline = load_data(sys.argv[1])
    comparison = load_data(sys.argv[2])
    
    # build dictionary mapping missing/added segments to cookies and vice versa
    segments = set()
    segments_missing = {}
    segments_added = {}
    cookies_with_new_segments = {}
    cookies_with_missing_segments = {}
    for cookie, segs in baseline.items():
        segments = segments | set(segs)
        # if a new cookie appears, we want to count the cookies and 
        # segments as having been added in the new version.
        if cookie not in comparison:
            for seg in baseline[cookie]:
                # map segments to cookies
                if seg in segments_added:
                    segments_added[seg].append(cookie)
                else:
                    segments_added[seg] = [cookie]
                # map cookies to segments
                if cookie in cookies_with_new_segments:
                    cookies_with_new_segments[cookie].append(seg)
                else:
                    cookies_with_new_segments[cookie] = [seg]
            continue
        missing = set(segs) - set(comparison[cookie])
        for m in missing:
            if m in segments_missing: segments_missing[m].append(cookie)
            else: segments_missing[m] = [cookie]
            if cookie in cookies_with_missing_segments: cookies_with_missing_segments[cookie].append(m)
            else: cookies_with_missing_segments[cookie] = [m]
        added = set(comparison[cookie]) - set(segs)
        for a in added:
            if a in segments_added: segments_added[a].append(cookie)
            else: segments_added[a] = [cookie]
            if cookie in cookies_with_new_segments: cookies_with_new_segments[cookie].append(a)
            else: cookies_with_new_segments[cookie] = [a]
    
    # build sets for summary section of report
    baseline_total = set(baseline.keys())
    baseline_empty = set([k for k in baseline if not baseline[k]])
    baseline_nonempty = baseline_total - baseline_empty
    test_total = set(comparison.keys())
    test_empty = set([k for k in comparison if len(comparison[k]) == 0])
    test_nonempty = test_total - test_empty
    
    # write report
    with open('test-report.txt', 'w') as report:
        report.write('Summary:\n')
        report.write('total cookies in baseline = %d\n' % len(baseline_total))
        report.write('empty cookies in baseline = %d\n' % len(baseline_empty))
        report.write('non-empty cookies in baseline = %d\n' % len(baseline_total - baseline_empty))
        report.write('total cookies in test = %d\n' % len(test_total))
        report.write('empty cookies in test = %d\n' % len(test_empty))
        report.write('non-empty cookies in test = %d\n' % len(test_total - test_empty))
        report.write('non-empty cookies in baseline only = %d\n' % len(baseline_nonempty - test_nonempty))
        report.write('non-empty cookies in test only = %d\n' % len(test_nonempty - baseline_nonempty))
        report.write('non-empty cookies in both = %d\n' % len(baseline_nonempty & test_nonempty))   # intersection
        report.write('non-empty cookies in either = %d\n' % len(baseline_nonempty | test_nonempty)) # union
        report.write('\nSegments with added cookies: %d / %d\n' % (len(segments_added), len(segments)))
        for i, s in enumerate(sorted(segments_added)):
            report.write('%d\t%s\t%d\t%s\n' % (i, s, len(segments_added[s]), sorted(segments_added[s])))
        report.write('\nSegments with missing cookies: %d / %d\n' % (len(segments_missing), len(segments)))
        for i, s in enumerate(sorted(segments_missing)):
            report.write('%d\t%s\t%d\t%s\n' % (i, s, len(segments_missing[s]), sorted(segments_missing[s])))
        report.write('\nCookies in extra segments: %d / %d\n' % (len(cookies_with_new_segments), len(baseline_total | test_total)))
        for i, c in enumerate(sorted(cookies_with_new_segments)):
            report.write('%d\t%s\t%d\t%s\n' % (i, c, len(cookies_with_new_segments[c]), sorted(cookies_with_new_segments[c])))
        report.write('\nCookies omitted from segments: %d / %d\n' % (len(cookies_with_missing_segments), len(baseline_total | test_total)))
        for i, c in enumerate(sorted(cookies_with_missing_segments)):
            report.write('%d\t%s\t%d\t%s\n' % (i, c, len(cookies_with_missing_segments[c]), sorted(cookies_with_missing_segments[c])))

main()
