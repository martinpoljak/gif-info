# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/color-table"

##
# Primary GifInfo module.
#

class GifInfo

    ##
    # General blocks module.
    #
    
    module Blocks
    
        ##
        # List of all the colors that can be in the image.
        #
        
        class GlobalColorTable < ColorTable
        end
    end
end
