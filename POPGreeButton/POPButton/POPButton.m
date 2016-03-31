//
//  POPButton.m
//  POPGreeButton
//
//  Created by 李言 on 16/3/31.
//  Copyright © 2016年 李言. All rights reserved.
//

#import "POPButton.h"

@interface POPButton()

@property (nonnull,nonatomic,strong,readwrite)UIButton  *ppbutton;

@property (nonnull,nonatomic,strong,readwrite)UIImage   *nomalImage;

@property (nonnull,nonatomic,strong,readwrite)UIImage   *selectImage;

@property (nonnull,nonatomic,strong,readwrite)UIImage   *sparkImage;

@property (nonnull,nonatomic,strong)CAEmitterCell       *emitterCell;

@property (nonnull,nonatomic,strong)CAEmitterCell       *exploreCell;

@property (nonnull,nonatomic,strong)CAEmitterLayer      *emitterLayer;
@property (nonnull,nonatomic,strong)CAEmitterLayer      *exploreLayer;

@property (nonnull,nonatomic,strong)NSArray             *emitterCells;

@property (nonatomic,assign)CGFloat                     sparkScale;

@property (nonatomic,assign)CGFloat                     sparkScaleRange;

@property (nullable,nonatomic,copy)POPButtonClick       popButtonClickBlock;

@end

@implementation POPButton


- (instancetype)init {
    
    if ([super init]) {
      
        self.emitterCells = @[self.emitterCell ,self.exploreCell];
        
        [self.layer addSublayer:self.exploreLayer];
        
        [self.layer addSublayer:self.emitterLayer];
        
        [self addSubview:self.ppbutton];
        
        self.sparkScale = 0.05;
        
        self.sparkScaleRange = 0.02;
    }
    return self;
}

+ (nullable instancetype)buttonWithNomalImage:(UIImage * _Nullable )nomalImage
                                  selectImage:(UIImage * _Nullable)selectImage
                                   sparkImage:(UIImage * _Nullable)sparkImage
                               popButtonClick:(POPButtonClick _Nullable)popBuutonClickBlock {
    
    POPButton *popbutton = [[POPButton alloc] init];
    
    popbutton.nomalImage   = nomalImage;
    
    popbutton.selectImage  = selectImage;
    
    popbutton.sparkImage   = sparkImage;
    
    popbutton.popButtonClickBlock = popBuutonClickBlock;

    return popbutton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
     [self.ppbutton setFrame:self.bounds];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.emitterLayer.emitterPosition = center;
    self.exploreLayer.emitterPosition = center;

}

- (void)buttonClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    if (sender.isSelected) {
        [self creatUnSeletedAnimatonWithDuration:1];
    } else {
        [self doEmitterAnimation];
        [self creatSeletedAnimatonWithDuration:0.5];
    }
    sender.selected = !sender.isSelected;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });

}

#pragma mark - Animation

- (void)creatSeletedAnimatonWithDuration:(NSTimeInterval)duration {
    self.transform = CGAffineTransformIdentity;
      [UIView animateKeyframesWithDuration:duration delay:0 options:kNilOptions animations:^{
          [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
              
              self.transform = CGAffineTransformMakeScale(1.5, 1.5);

          }];
          [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
             
              self.transform = CGAffineTransformMakeScale(0.8, 0.8);
          }];
          [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            
              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
          }];

      } completion:^(BOOL finished) {

          !self.popButtonClickBlock?:self.popButtonClickBlock(self.ppbutton);
         
      }];
}

- (void)creatUnSeletedAnimatonWithDuration:(NSTimeInterval)duration {
    
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
        
        !self.popButtonClickBlock?:self.popButtonClickBlock(self.ppbutton);
        
    }];
}


- (void)doEmitterAnimation {
    
    self.emitterLayer.beginTime = CACurrentMediaTime();
    [self.emitterLayer setValue:@80 forKeyPath:@"emitterCells.charge.birthRate"];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [self explode];
    });
}

- (void)explode {
    [self.emitterLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    self.exploreLayer.beginTime = CACurrentMediaTime();
    [self.exploreLayer setValue:@500 forKeyPath:@"emitterCells.explosion.birthRate"];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [self stop];
    });
}

- (void)stop {
    [self.emitterLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    [self.exploreLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}


#pragma mark - getter

- (UIButton *)ppbutton{

    if (!_ppbutton) {
        
        _ppbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_ppbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ppbutton;

}

- (CAEmitterCell *)exploreCell {
    if (!_exploreCell) {
        
        _exploreCell = [CAEmitterCell emitterCell];
        _exploreCell.name = @"explosion";
        _exploreCell.alphaRange = 0.20;
        _exploreCell.alphaSpeed = -1.0;
        
        _exploreCell.lifetime = 0.7;
        _exploreCell.lifetimeRange = 0.3;
        _exploreCell.birthRate = 0;
        _exploreCell.velocity = 40.00;
        _exploreCell.velocityRange = 10.00;
    }
    return _exploreCell;
    
}


- (CAEmitterLayer *)exploreLayer {
    
    if (!_exploreLayer) {
        _exploreLayer = [CAEmitterLayer layer];
        _exploreLayer.name = @"emitterLayer";
        _exploreLayer.emitterShape = kCAEmitterLayerCircle;
        _exploreLayer.emitterMode  = kCAEmitterLayerOutline;
        _exploreLayer.emitterSize = CGSizeMake(25, 0);
        _exploreLayer.emitterCells = @[self.exploreCell];
        _exploreLayer.renderMode = kCAEmitterLayerOldestFirst;
        _exploreLayer.masksToBounds = NO;
        _exploreLayer.seed = 1366128504;
    }
    
    return _exploreLayer;
    
}

- (CAEmitterCell *)emitterCell {
    if (!_emitterCell) {
        
        _emitterCell = [CAEmitterCell emitterCell];
        _emitterCell.name = @"charge";
        _emitterCell.alphaRange = 0.20;
        _emitterCell.alphaSpeed = -1.0;
        
        _emitterCell.lifetime = 0.3;
        _emitterCell.lifetimeRange = 0.1;
        _emitterCell.birthRate = 0;
        _emitterCell.velocity = -40.0;
        _emitterCell.velocityRange = 0.00;
    }
    return _emitterCell;

}

- (CAEmitterLayer *)emitterLayer {
    
    if (!_emitterLayer) {
        _emitterLayer = [CAEmitterLayer layer];
        _emitterLayer.name = @"emitterLayer";
        _emitterLayer.emitterShape = kCAEmitterLayerCircle;
        _emitterLayer.emitterMode  = kCAEmitterLayerOutline;
        _emitterLayer.emitterSize = CGSizeMake(25, 0);
        _emitterLayer.emitterCells = @[self.emitterCell];
        _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
        _emitterLayer.masksToBounds = NO;
        _emitterLayer.seed = 1366128504;
    }
    
    return _emitterLayer;

}



#pragma mark - setter

- (void)setNomalImage:(UIImage *)nomalImage {

    _nomalImage = nomalImage;

    [self.ppbutton setImage:_nomalImage forState:UIControlStateNormal];
    
}

- (void)setSelectImage:(UIImage *)selectImage {
    
    _selectImage = selectImage;
    
    [self.ppbutton setImage:_selectImage forState:UIControlStateSelected];

}

- (void)setSparkImage:(UIImage *)sparkImage {

    _sparkImage = sparkImage;
    for (CAEmitterCell *cell in self.emitterCells) {
       cell.contents = (id)[_sparkImage CGImage];
    }
}

- (void)setSparkScale:(CGFloat)sparkScale {
    _sparkScale = sparkScale;
    
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.scale = _sparkScale;
    }
}

- (void)setSparkScaleRange:(CGFloat)sparkScaleRange {
    _sparkScaleRange = sparkScaleRange;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.scaleRange = _sparkScaleRange;
    }

}



@end
