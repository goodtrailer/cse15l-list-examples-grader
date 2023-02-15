BUILD_DIR="./build"
SOURCE_DIR="./student-submission"
SOURCE_FILE="ListExamples.java"
TEST="TestListExamples"

CPATH_UNIX=".:./lib/*:$BUILD_DIR"
CPATH_WIN=".;./lib/*;$BUILD_DIR"
CPATH="$CPATH_UNIX:;$CPATH_WIN"

function cleanup()
{
	echo -e "\n\n---\n\n$1"
	rm -rf $SOURCE_DIR $BUILD_DIR
	exit
}

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

if [ ! -f  "$SOURCE_DIR/$SOURCE_FILE" ]
then
	cleanup "GRADING ERROR: $SOURCE_FILE not found!"
fi

mkdir -p $BUILD_DIR
javac -cp $CPATH *.java "$SOURCE_DIR/$SOURCE_FILE" -d $BUILD_DIR

if [ $? != 0 ]
then
	cleanup "GRADING ERROR: $SOURCE_FILE compilation failed!"
fi

RESULT=`java -cp $CPATH org.junit.runner.JUnitCore $TEST`

if [ -z `echo "$RESULT" | grep -o "FAILURES!!!"` ]
then
	TOTAL=`echo "$RESULT" | grep -oP "(?<=OK \()[0-9]*"`
	PASSED=$TOTAL
else
	echo "$RESULT"
	TOTAL=`echo "$RESULT" | grep -oP "(?<=Tests run: )[0-9]*"`
	FAILED=`echo "$RESULT" | grep -oP "(?<=Failures: )[0-9]*"`
	PASSED=$(( TOTAL - FAILED ))
fi

cleanup "GRADING SUCCESS: $PASSED/$TOTAL points"
