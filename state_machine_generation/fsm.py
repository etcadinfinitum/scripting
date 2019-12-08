#!/bin/env python3

class Machine(object):

    def __init__(self, text):
        # used for method with case statements
        self.name = text
        self.state_names = []
        self.event_names = []
        self.state_to_event = {}
        self.event_to_state = {}
        self.state_action_strings = {}
        self.event_action_strings = {}
        self.invalid_event = 'INVALID_EVENT'

    def header(self, text):
        self.header = text

    def footer(self, text):
        self.footer = text

    def state(self, state_name, action_string, edge_list=None):
        self.state_names.append(state_name)
        self.state_action_strings[state_name] = action_string
        if edge_list is not None:
            if state_name not in self.state_to_event:
                self.state_to_event[state_name] = {}
            for e in edge_list: self.state_to_event[state_name].update(e)
    def edge(self, event_name, next_state, optional_action_string=''):
        if event_name not in self.event_names: 
            self.event_names.append(event_name)
            self.event_action_strings[event_name] = optional_action_string
        return {event_name: next_state}
    def edges(self, *args_list):
        events = []
        for args in args_list:
            events.append(self.edge(*args))
        return events

    def gen(self):
        # header
        print(self.header)
        # state enum
        print('enum State {')
        for s in list(set(self.state_names)):
            print('  %s_STATE,' % s)
        print('};\n')
        # event enum
        print('enum Event {')
        for e in list(set(self.event_names)):
            print('  %s_EVENT,' % e)
        print('  %s' % self.invalid_event)
        print('};\n')
        # event strings
        print('const char * EVENT_NAMES[] = {')
        for e in list(set(self.event_names)):
            print('  "%s",' % e)
        print('};\n')
        # forward declare get_next_event()
        print('Event get_next_event();\n')
        # convert string to event enum
        print('Event string_to_event(string event_string) {')
        for e in list(set(self.event_names)):
            print('  if (event_string == "%s") return %s_EVENT;' % (e, e))
        print('  return %s;\n}' % self.invalid_event)
        # state machine header
        print('int %s(State initial_state) {' % self.name)
        print('  State state = initial_state;')
        print('  Event event;')
        print('  while (true) {')
        print('    switch (state) {')
        # core state machine logic
        for state in self.state_names:
            print('      case %s_STATE:' % state)
            print(' ' * 8 + 'cerr << "state %s" << endl;' % state)
            if state in self.state_action_strings:
                print(self.state_action_strings[state])
            print(' ' * 8 + ' event = get_next_event();')
            print(' ' * 8 + 'cerr << "event " << EVENT_NAMES[event] << endl;')
            print(' ' * 8 + 'switch (event) {')
            if state in self.state_to_event:
                for e in self.state_to_event[state]:
                    print(' ' * 10 + 'case %s_EVENT:' % e)
                    print(' ' * 12 + 'state = %s_STATE;' % self.state_to_event[state][e])
                    print(' ' * 12 + 'break;')
            print(' ' * 10 + 'default:')
            print(' ' * 12 + 'cerr << "INVALID EVENT " << event << " in state %s" << endl;' % state)
            print(' ' * 12 + 'return -1;\n%s}' % (' ' * 8))
            print(' ' * 8 + 'break;')
        print('    }\n  }\n}')
        # last, but not least
        print(self.footer)
