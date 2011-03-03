# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/fixed-block"
require "frozen-objects"

##
# Primary GifInfo module.
#
    
module GifInfo

    ##
    # General blocks module.
    #
    
    module Blocks
    
        ##
        # Used to specify transparency settings and control animations.
        #
        
        class GraphicsControlExtension < FixedBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                skip {3}
                byte (:packed) do
                    number (:reserved) {3}
                    number (:disposal_method) {3}
                    boolean :user_input
                    boolean :transparent_color
                end
                uint16 :delay_time
                uint8 :transparent_color_index
                skip {1}
            end
        end
    end
end
