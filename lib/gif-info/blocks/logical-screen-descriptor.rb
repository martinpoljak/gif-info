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
        # Tells the decoder how much room this image will take up.
        #
        
        class LogicalScreenDescriptor < FixedBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                uint16 :canvas_width
                uint16 :canvas_height
                byte (:packed) do 
                    boolean :global_color_table
                    number (:global_color_table_resolution) {3}
                    boolean :global_color_table_sort
                    number (:global_color_table_size) {3}
                end
                uint8 :background_color_index
                uint8 :pixel_aspect_ratio
            end
        end
    end
end
