# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/dynamic-block"
require "frozen-objects"

##
# Primary GifInfo module.
#

class GifInfo

    ##
    # General blocks module.
    #
    
    module Blocks
    
        ##
        # Application specific information to embedded in the GIF file itself.
        #
        
        class ApplicationExtension < DynamicBlock
            
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                skip {1}
                uint8 :extension_type
                uint8 :block_size
                string (:application_identifier) {8}
                string (:application_authentication_code) {3}
            end
        end
    end
end
