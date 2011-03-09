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
        # Contents textual comment data.
        #
        
        class CommentExtension < DynamicBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                skip {1}
                uint8 :extension_type
            end
        end
    end
end
