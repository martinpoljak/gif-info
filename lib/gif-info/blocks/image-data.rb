# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/dynamic-block"

##
# Primary GifInfo module.
#

class GifInfo

    ##
    # General blocks module.
    #
    
    module Blocks
    
        ##
        # series of output codes which tell the decoder which colors to 
        # spit out to the canvas.
        #
        
        class ImageData < DynamicBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                uint8 :lzw_minimum_code_size
            end
        end
    end
end
