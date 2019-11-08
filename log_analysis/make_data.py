import random
import string
import secrets

evaluator_size = random.randint(1000, 3000)

useless = '16:06:56.659 [main] ERROR com.audiencescience.app.smac.functional.EvaluateProfiles - countOfTrueSegments = 60825464, trueSegmentIdsHashCodeXor = 1303658793'
prefix = '16:06:56.398 [main] ERROR com.audiencescience.app.smac.functional.EvaluateProfiles - evaluated: '

def make_segments():
    segments = set()
    segments_size = random.randint(2000, 4000)
    for n in range(segments_size):
        char = random.choice(string.ascii_uppercase)
        first = random.randint(1000, 10000)
        second = random.randint(10000, 100000)
        segment = char + '0' + str(first) + '_' + str(second)
        if segment not in segments:
            segments.add(segment)
    return segments

def make_baseline(segments):
    cookies = {}
    for r in range(random.randint(300, 1000)):
        cookie = secrets.token_hex(16)   # no. of bytes: 16
        num = random.randint(5, 40)
        if num % 10 != 0:
            cookies[cookie] = random.sample(segments, k=num)
        else:
            cookies[cookie] = []
    return cookies

def make_new(baseline, segments):
    new = {}
    for i, k in enumerate(baseline.keys()):
        # get number of items in segments list
        if len(baseline[k]) > 0:
            size = len(baseline[k]) // 3
            if i % 5 == 0:
                # don't change anything
                new[k] = baseline[k]
            elif i % 5 == 1:
                # remove a few things
                new[k] = random.sample(baseline[k], k=size)
            elif i % 5 == 2:
                # add a few things; keep baseline segments intact
                segs = baseline[k]
                segs.extend([f for f in random.sample(segments, k=size) if f not in segs])
                new[k] = segs
            elif i % 5 == 3:
                # add and remove things
                segs = random.sample(baseline[k], k=size//2)
                segs.extend([f for f in random.sample(segments, k=size//2) if f not in segs])
                new[k] = segs
            else:
                # omit cookie altogether, make a new one
                cookie = secrets.token_hex(16)   # no. of bytes: 16
                if i % 7 == 0:
                    new[cookie] = []
                else:
                    new[cookie] = baseline[k]
        else:
            new[k] = []
    return new

def main():
    segments = make_segments()
    baseline = make_baseline(segments)
    with open('test-evaluator-baseline.log', 'w') as base:
        for i, k in enumerate(baseline):
            if i % 10 == 0:
                base.write(useless + '\n')
            base.write(prefix + k + ' ==> ' + str(baseline[k]).replace('\'', '') + '\n')
    new = make_new(baseline, segments)
    with open('test-evaluator.log', 'w') as n:
        for i, k in enumerate(new):
            if i % 10 == 0:
                n.write(useless)
            n.write(prefix + k + ' ==> ' + str(new[k]).replace('\'', '') + '\n')

main()
