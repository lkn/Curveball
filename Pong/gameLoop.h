
int compareScoreLines (const void * a, const void * b)
{
	//NSLog(@"compare");
	NSString ** aString = (NSString**)a;
	NSString ** bString = (NSString**)b;
	//NSLog(@"hi");
	//NSLog(@"%@ %@",*aString,*bString);
	NSArray *scoreAArray = [*aString componentsSeparatedByString: @" "];
	NSArray *scoreBArray = [*bString componentsSeparatedByString: @" "];

	int av = [[scoreAArray objectAtIndex:1] intValue];
	int bv = [[scoreBArray objectAtIndex:1] intValue];
	//NSLog(@"%d %d",av,bv);
	return bv-av;
}
