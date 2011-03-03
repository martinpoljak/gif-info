# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

##
# Primary GifInfo module.
#

module GifInfo
    
    ##
    # Decoder and holder of block-encoded GIF data.
    #
    
    class Body
    
        ##
        # IO object.
        #
        
        @io
        
        ##
        # Data contained in the data body.
        #
        
        @data
        
        ##
        # Constructor.
        # @param [IO] io IO object
        #
        
        def initialize(io)
            @io = io
        end
        
        ##
        # Returns data.
        # If block given, streams it, in otherwise returns full value.
        #
        # @yield [String] chunk in size of one data block of the raw data
        # @return [String] full data content
        # 
        
        def data(&block)
            if not @data.nil?
                return @data
            end
            
            if not block.nil?
                loop do
                    size = @io.getbyte
                    break if size <= 0
                    block.call(@io.read(size))
                end
            else
                data = ""
                self.data do |chunk|
                    data << chunk
                end
                @data = data
                
                return @data
            end
        end
        
        ##
        # Returns bytesize of the data body.
        # @return [Integer] length in bytes
        #
        
        def bytesize
            self.data.bytesize
        end
    end
end
