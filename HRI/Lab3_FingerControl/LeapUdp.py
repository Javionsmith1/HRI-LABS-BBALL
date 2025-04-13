################################################################################
# Copyright (C) 2012-2016 Leap Motion, Inc. All rights reserved.               #
# Leap Motion proprietary and confidential. Not for distribution.              #
# Use subject to the terms of the Leap Motion SDK Agreement available at       #
# https://developer.leapmotion.com/sdk_agreement, or another agreement         #
# between Leap Motion and you, your company or other organization.             #
################################################################################

import sys, thread, time, socket, os
sys.path.append(os.getcwd() + '\\LeapSDK')
import Leap

destination = ('127.0.0.1' , 14001)
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  # UDP
sock.sendto('test', destination)


class SampleListener(Leap.Listener):
    finger_names = ['Thumb', 'Index', 'Middle', 'Ring', 'Pinky']
    bone_names = ['Metacarpal', 'Proximal', 'Intermediate', 'Distal']

    def on_init(self, controller):
        print("Initialized")

    def on_connect(self, controller):
        print("Connected")

    def on_disconnect(self, controller):
        # Note: not dispatched when running in a debugger.
        print("Disconnected")

    def on_exit(self, controller):
        print("Exited")

    def on_frame(self, controller):
        # Get the most recent frame and report some basic information
        frame = controller.frame()

        udp_msg = '';

        msg = "Frame id: %d, timestamp: %d, hands: %d, fingers: %d\n" % (
              frame.id, frame.timestamp, len(frame.hands), len(frame.fingers))

        #print msg
        udp_msg += msg
        
        # Get hands
        for hand in frame.hands:

            handType = "Left hand" if hand.is_left else "Right hand"

            msg = "  %s, id %d, position: %s, fingers: %s\n" % (
                handType, hand.id, hand.palm_position, len(hand.fingers))
            #print msg
            udp_msg += msg                

            # Get the hand's normal vector and direction
            normal = hand.palm_normal
            direction = hand.direction

            # Calculate the hand's pitch, roll, and yaw angles
            msg = "  x_basis: %s, y_basis: %s, z_basis: %s\n" % (
                hand.basis.x_basis,
                hand.basis.y_basis,
                hand.basis.z_basis)
            #print msg
            udp_msg += msg                

            # Get arm bone
            arm = hand.arm
            msg = "  Arm x_basis: %s, wrist position: %s, elbow position: %s\n" % (
                arm.basis.x_basis, #arm.direction,
                arm.wrist_position,
                arm.elbow_position)
            #print msg
            udp_msg += msg                

            # Get fingers
            for finger in hand.fingers:

                msg = "    %s finger, id: %d, length: %fmm, width: %fmm\n" % (
                    self.finger_names[finger.type],
                    finger.id,
                    finger.length,
                    finger.width)
                #print msg
                udp_msg += msg                

                # Get bones
                for b in range(0, 4):
                    bone = finger.bone(b)
                    msg = "      Bone: %s, start: %s, end: %s, direction: %s\n" % (
                        self.bone_names[bone.type],
                        bone.prev_joint,
                        bone.next_joint,
                        bone.direction)
                    #print msg
                    udp_msg += msg                

        if not frame.hands.is_empty:
            msg = ""
            #udp_msg = msg                

        sock.sendto(udp_msg, destination)
        print(udp_msg)

def main():
    # Create a sample listener and controller
    listener = SampleListener()
    controller = Leap.Controller()

    # Have the sample listener receive events from the controller
    controller.add_listener(listener)

    # Keep this process running until Enter is pressed
    print("Press Enter to quit...")
    try:
        sys.stdin.readline()
    except KeyboardInterrupt:
        pass
    finally:
        # Remove the sample listener when done
        controller.remove_listener(listener)


if __name__ == "__main__":
    main()
