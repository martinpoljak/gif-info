# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "stringio"
require "struct-fx"

require "gif-info/blocks/header-block"
require "gif-info/blocks/logical-screen-descriptor"
require "gif-info/blocks/global-color-table"
require "gif-info/blocks/local-color-table"
require "gif-info/blocks/plain-text-extension"
require "gif-info/blocks/comment-extension"
require "gif-info/blocks/application-extension"
require "gif-info/blocks/graphics-control-extension"
require "gif-info/blocks/image-descriptor"
require "gif-info/blocks/image-data"
require "gif-info/blocks/trailer"

##
# Primary GifInfo module.
#

class GifInfo

    ############################################################
    ## STATIC PART
    ############################################################

    ##
    # Defines structure of the block head.
    #
    
    BLOCK_HEAD = StructFx::new do
        uint8 :block_introducer
        uint8 :extension_label
    end
    
    ##
    # Parses the GIF file.
    #
    # @param [IO] io IO object where offset 0 is start of the GIF file
    # @yield [Blocks::ApplicationExtension]
    # @yield [Blocks::CommentExtension]
    # @yield [Blocks::GlobalColorTable]
    # @yield [Blocks::GraphicsControlExtension]
    # @yield [Blocks::HeaderBlock]
    # @yield [Blocks::ImageData]
    # @yield [Blocks::ImageDescriptor]
    # @yield [Blocks::LocalColorTable]
    # @yield [Blocks::LogicalScreenDescriptor]
    # @yield [Blocks::PlainTextExtension]
    # @yield [Blocks::Trailer]
    # @see http://www.matthewflickinger.com/lab/whatsinagif/
    #
    
    def self.parse(io)
        __parse(io) do |block|
        
            # Saves position of beginning of the next block set by
            # inner parser
            position = io.pos               
            
            # Yields block and allows application seek trough the file 
            # according to its needs
            yield block
            
            # Seeks to position at beginning of the next block
            io.seek(position)
            
        end
    end
    
    
    private
    
    ##
    # Just performs parsing of the GIF file.
    #
    
    def self.__parse(io)
        if io.kind_of? String
            io = StringIO::new(io)
        end
        
        # Header Block
        yield Blocks::HeaderBlock::new(io)
        
        # Logical Screen Descriptor
        yield lsd = Blocks::LogicalScreenDescriptor::new(io)

        # Global Color Table
        packed = lsd.header.data.packed.data
        if packed.global_color_table
            size = packed.global_color_table_size
            yield Blocks::GlobalColorTable::new(io, size)
        end

        # Extensions
        reader = self::BLOCK_HEAD
        length = reader.length

        loop do
            reader << (io.read(length) << "\0")     # adds zero character for cases, trailer is last byte of the file
            header = self::BLOCK_HEAD.data
            io.seek(-length, IO::SEEK_CUR)

            case header.block_introducer
                when 0x21   # extension
                    case header.extension_label
                        when 0xF9   # graphics control
                            yield Blocks::GraphicsControlExtension::new(io)
                        when 0xFF   # application
                            yield Blocks::ApplicationExtension::new(io)
                        when 0xFE   # comment
                            yield Blocks::CommentExtension::new(io)
                        when 0x01   # plain text
                            yield Blocks::PlainTextExtension::new(io)
                        else
                            raise Exception::new("Invalid format: 0x01, 0xF9, 0xFE or 0xFF expected, but 0x" << header.block_introducer.to_s(16).upcase << " found at position " << (io.pos + 1).to_s << ".")
                    end
                    
                when 0x2C   # image descriptor
                
                    # Image Descriptor
                    yield desc = Blocks::ImageDescriptor::new(io)
                    
                    # Local Color Table
                    if (d = desc.header.data.packed.data).local_color_table
                        size = d.local_color_table_size
                        yield Blocks::LocalColorTable::new(io, size)
                    end
                    
                    # Image Data
                    yield Blocks::ImageData::new(io)

                when 0x3B   # trailer
                    yield Blocks::Trailer::new(io)
                    break
                    
                else
                    raise Exception::new("Invalid format: 0x21, 0x2C or 0x3B expected, but 0x" << header.block_introducer.to_s(16).upcase << " found at position " << io.pos.to_s << ".")
            end
        end
    end
    
    
    public
    
    ##
    # Considers stream, performs analyzing and returns info object
    # as result.
    #
    # @param [IO] io IO object with GIF data
    # @return [GifInfo] info object
    #
    
    def self.analyze_io(io)
        self::new(io)
    end

    ##
    # Analyzes string with GIF data and returns info object.
    #
    
    def self.analyze_string(string)
        self::analyze_io(StringIO::new(string))
    end

    ##
    # Analyzes file and returns info object back.
    # 
    # @param [String] filename file path
    # @return [GifInfo] info object
    #
    
    def self.analyze_file(filename)
        File::open(filename, "rb") do |io|
            self.analyze_io(io)
        end
    end


    ############################################################
    ## INSTANCE PART
    ############################################################
    
    ##
    # Type of the file. If it isn't +:GIF+, it means, file isn't
    # valid GIF gile.
    #
    # @return [Symbol] always +:GIF+
    #
    
    attr_reader :type
    @type
    
    ##
    # Version of the GIF standard. Can be +:87a+ or +?89a+.
    # @return [Symbol] GIF standard version
    #
    
    attr_reader :version
    @version
    
    ##
    # Width of the image. (Width of the canvas.)
    # @return [Integer] width
    #
    
    attr_reader :width
    @width
    
    ##
    # Height of the image. (Height of the canvas.)
    # @return [Integer] height
    #
    
    attr_reader :height
    @height
    
    ##
    # Pixel aspect ratio. See standard what it is.
    # @return [Integer] pixel aspect ration
    #
    
    attr_reader :pixel_aspect_ratio
    @pixel_aspect_ratio
    
    ##
    # Color resolution in number of colors which can be encoded 
    # according to global table. If local tables found, it's +nil+.
    #
    # @return [Integer] color count
    #
    
    attr_reader :color_resolution
    @color_resolution
    
    ##
    # Comments inside the file. GIF file can theorethically contain
    # unlimtited number of the comment blocks, so it returns array.
    #
    # @return [Array] array with comments
    #
    
    attr_reader :comments
    @comments
    
    ##
    # Contains images count. More images in one file are characteristics
    # for the animated GIF files.
    #
    # @return [Integer] images count
    #
    
    attr_reader :images_count
    @images_count
    
    ##
    # Contains the GIF duration, for multiple image files. In animaged GIF
    # files, frames specify a delay from one another, and the duration of
    # animation is the total of all the frame delays. A nonanimaged GIF
    # hence has a duration of 0.
    #
    # @return [Float] duration in seconds
    #
    
    attr_reader :duration
    @duration
    
    ##
    # Indicates animation is cyclic.
    #
    
    @cyclic

    ##
    # Indicates, file is animated.
    #
    
    @animated
    
    ##
    # Indicates, at least one image in file has some color transparent.
    #
    
    @transparent

    ##
    # Indicates, at least one image in file is rendered interlaced.
    #
    
    @interlaced
    
    ##
    # Constructor.
    # @param [IO] io IO object with GIF data
    #
    
    def initialize(io)
        @comments = [ ]
        @images_count = 0
        @cyclic = false
        @animated = false
        @transparent = false
        @interlaced = false
        @duration = 0
        
        self.consider! io
    end
    
    ##
    # Considers IO object, analyzes it and sets result ot the object.
    # @param [IO] io IO object with GIF data
    #
    
    def consider!(io)
        self.class::parse(io) do |block|
        
            # Header Block
            if block.kind_of? GifInfo::Blocks::HeaderBlock
                header = block.header.data
                @type = header.signature.to_sym         # type
                @version = header.version.to_sym        # version

            # Logical Screen Descriptor
            elsif block.kind_of? GifInfo::Blocks::LogicalScreenDescriptor
                header = block.header.data
                packed = header.packed.data
                
                @width = header.canvas_width            # width
                @height = header.canvas_height          # height
                
                value = header.pixel_aspect_ratio       # pixel aspect ratio
                value = nil if value <= 0               #
                @pixel_aspect_ratio = value             #
                
                if packed.global_color_table            # color resolution
                    @color_resolution = 2 ** (packed.global_color_table_size + 1)
                end
                
            # Comments
            elsif block.kind_of? GifInfo::Blocks::CommentExtension
                @comments << block.body.data            # comments
                
            # Image Descriptor
            elsif block.kind_of? GifInfo::Blocks::ImageDescriptor
                packed = block.header.data.packed.data 
                
                @images_count += 1                                 # images count
                @animated = true if @images_count == 2             # animated
                @interlaced |= packed.interlace                    # interlaced
                
                if packed.local_color_table and (not @color_resolution.nil?) and (packed.local_color_table_size != @color_resolution)
                    @color_resolution = nil                         # resets color resolution if local color table found
                end                                                 # and global and local aren't equivalent
                
            # Application Extension
            elsif block.kind_of? GifInfo::Blocks::ApplicationExtension
                header = block.header.data
                if (header.application_identifier == "NETSCAPE") and (header.application_authentication_code == "2.0")
                    @cyclic = true                                  # cyclic
                end
                
            # Graphics Control Extension
            elsif block.kind_of? GifInfo::Blocks::GraphicsControlExtension
                packed = block.header.data.packed.data
                @transparent |= packed.transparent_color            # transparent
                @duration += block.header.data.delay_time.to_f / 100 # delay time is in hundredths of a second
                
            end
            
        end

        ##
        # Indicates animation is cyclic. In strange GIF files can be set
        # although file isn't animated and contains single image only.
        #
        # @return [Boolean] +true+ if yes, +false+ in otherwise
        # 
        
        def cyclic?
            @cyclic
        end
         
        ##
        # Indicates file is animated. It can be set to +true+ although
        # animation isn't run because it's set if file contains 
        # more images.
        #
        # @return [Boolean] +true+ if yes, +false+ in otherwise
        # 
        
        def animated?
            @animated
        end
        
        ##
        # Indicates, at least one image in file has some color 
        # transparent. It of sure doesn't mean, image is transparent.
        # It only means, transparency is turned on.
        #
        # @return [Boolean] +true+ if yes, +false+ in otherwise
        # 
        
        def transparent?
            @transparent
        end

        ##
        # Indicates, at least one image in file is rendered interlaced.
        # @return [Boolean] +true+ if yes, +false+ in otherwise
        # 
        
        def interlaced?
            @interlaced
        end
        
    end
    
end
