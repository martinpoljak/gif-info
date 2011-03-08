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
            
            ##
            # Returns data body.
            #
            # @param [Integer] skip number of bytes to skip before data
            # @return [Body] data body
            #

            def body
                super(__additional)
            end
            
            ##
            # Skips block in stream.
            #
     
            def skip!
                super(__additional)
            end
 
            ##
            # Returns block size.
            # @return [Integer] block size in bytes
            #
           
            def bytesize
                super + __additional
            end

            
            private
            
            ##
            # Returns additional length.
            #
            
            def __additional
                self.header.data.block_size
            end
        end
    end
end
