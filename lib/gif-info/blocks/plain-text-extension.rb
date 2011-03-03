# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/dynamic-block"
require "gif-info/body"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # General blocks module.
    #
    
    module Blocks
    
        ##
        # Specifies text which user wish to have rendered on the image.
        # Support of this feature is very rare.
        #
        
        class PlainTextExtension < DynamicBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                skip {1}
                uint8 :extension_type
                uint8 :block_size
            end
            
            def body
                super(self.header.data.block_size)
            end
        end
    end
end
