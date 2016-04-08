//
//  BSTableViewModel.m
//  babylearn
//
//  Created by Bobby on 15/10/20.
//  Copyright (c) 2015年 ci123. All rights reserved.
//

#import "BSTableViewModel.h"

@interface BSTableViewModel ()

@property (strong, nonatomic, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation BSTableViewModel

- (void)initialize
{
    [super initialize];
    
    self.page = 1;
    self.perPage = 30;
    self.isMore = YES;
    self.dataSource = [NSArray array];
    
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithEnabled:[self requestEnableSignal] signalBlock:^RACSignal *(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
//    RAC(self, shouldDisplayEmptyDataSet) = [RACSignal
//        combineLatest:@[ self.requestRemoteDataCommand.executing, RACObserve(self, dataSource) ]
//        reduce:^(NSNumber *executing, NSArray *dataSource) {
//            RACSequence *sequenceOfSequences = [dataSource.rac_sequence map:^(NSArray *array) {
//                @strongify(self)
//                NSParameterAssert([array isKindOfClass:[NSArray class]]);
//                return array.rac_sequence;
//            }];
//            return @(!executing.boolValue && sequenceOfSequences.flatten.array.count == 0);
//        }];
    
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [RACSignal empty];
}

- (RACSignal *)requestEnableSignal
{
    return [RACSignal return:@(YES)];
}
@end
