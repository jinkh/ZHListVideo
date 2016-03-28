## Who is this for?

- Short list of videos, decoupling, automatically detect play and pause.

## Usage
In UITableViewCell:

-(void)dealloc
{
    [videoView destroy];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    videoView = [[ZHShortPlayerView alloc] initWithFrame:CGRectZero withIdentifier:reuseIdentifier];
    [self addSubview:videoView];

    }
    return self;
}

-(void)fillData:(VideoModel *)data
{
    [videoView setVideoUrl:data.videUrl coverUrl:data.picUrl];
}

