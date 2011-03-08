# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "abstract"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # General block.
    # @abstract
    #
    
    class Block
    
        ##
        # Holds IO object.
        #
        
        @io
        
        ##
        # Holds block position in stream.
        #
        
        @position
    
        ##
        # Returns header.
        #
        
        def header
            nil
        end
        
        ##
        # Returns body.
        #
        
        def body
            nil
        end
        
        ##
        # Constructor.
        # @param [IO] io some IO object at appropriate offset
        #
        
        def initialize(io)
            @io = io
            @position = io.pos
            self.skip!
        end
        
        ##
        # Skips block in stream.
        # @abstract
        #
        
        def skip!
            not_implemented
        end
        
        ##
        # Prepares to reading position.
        #
        
        def prepare!
            @io.seek(@position)
        end
        
        ##
        # Returns size of block in bytes.
        # @abstract
        #
                
        def bytesize
            not_implemented
        end
    end
end
