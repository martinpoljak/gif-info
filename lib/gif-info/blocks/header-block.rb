# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/fixed-block"
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
        # Signature and version.
        #
        
        class HeaderBlock < FixedBlock
        
            ##
            # Byte structure.
            #
            
            STRUCTURE = Frozen << Proc::new do
                string (:signature) {3}
                string (:version) {3}
            end
        end
    end
end
