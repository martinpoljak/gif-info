# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "struct-fx"     # 0.1.1
require "gif-info/block"

##
# Primary GifInfo module.
#

module GifInfo

    ##
    # Abstract fixed-size block which contains header only. 
    # @abstract
    #
    
    class FixedBlock < Block
    
        ##
        # Holds header.
        #
        
        @header
        
        ##
        # Constructor.
        # @param [IO] io IO object
        # 
        
        def initialize(io)
            super(io)
            self.header.data
        end
        
        ##
        # Returns header struct.
        # @return [StructFx] struct
        #
        
        def header
            if @header.nil?
                @header = StructFx::new(&self.class::STRUCTURE)
                @header << io.read(@header.bytesize)
            end
            
            return @header
        end
        
        ##
        # Returns block size.
        # @return [Integer] block size in bytes
        #
        
        def bytesize
            self.header.bytesize
        end
    end
end
