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
        # Block for describing single image in GIF.
        #
        
        class ImageDescriptor < FixedBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                skip {1}
                uint16 :image_left
                uint16 :image_top
                uint16 :image_width
                uint16 :image_height
                byte (:packed) do
                    boolean :local_color_table
                    boolean :interlace
                    boolean :local_color_table_sort
                    number (:reserved) {2}
                    number (:local_color_table_size) {3}
                end
            end
        end
    end
end
