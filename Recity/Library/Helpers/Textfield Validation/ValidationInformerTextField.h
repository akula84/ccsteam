//
//  InformerableTextField.h
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "VerifiableTextField.h"

@interface ValidationInformerTextField : VerifiableTextField

@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *informationLabel;

- (void)turnIntoValidState;

@end
