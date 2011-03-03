# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "gif-info/raw-block"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # General color table block.
    # @abstract
    #
    
    class ColorTable < RawBlock
    
        ##
        # Constructor.
        #
        # @param [IO] io IO object
        # @param [Integer] size size as it's reported by header blocks
        #
        
        def initialize(io, size)
            super(io, 3 * (2 ** (size + 1)))
        end
        
    end
    
end
