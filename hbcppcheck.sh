#!/usr/bin/env bash

# Copyright (C) Horizon Robotics, Inc. - All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

LANG="cpp"
FORMAT_MODE="FULL_MODE"
LINES_STR=""

usage()
{
  echo "Usage: `basename $0` [options] [<file type> <file>] [<start>:<end>[,<start>:<end>]]"
  echo "Supports c, cpp and json"
  echo "Command options:"
  echo "  -l    full inspection, default mode"
  echo "        e.g. hbcppcheck.sh test.cpp or hbcppcheck.sh -lcpp test.cpp"
  echo "  -i    incremental inspection"
  echo "        e.g. hbcppcheck.sh -ic test.c"
  echo "  -n    incremental inspection by line numbers, only suport file"
  echo "        e.g. hbcppcheck.sh -nc test.c 100:200,300:400"
  echo "                                        "
  echo "default mode is full inspection"
  echo "default language is cpp"
  exit 1
}

clang_format_c()
{
  #delete space(s) at the end of line
  sed -i 's/ *$//' $1
  #replace tab to 4 spaces
  sed -i 's/\t/    /g' $1
  #before clang-format, do dos2unix
  dos2unix $1 > /dev/null 2>&1
  #refer to https://gitee.com/mirrors/linux/blob/master/.clang-format
  clang-format -i $LINES_STR $1 -style="{BasedOnStyle: llvm,
                            AccessModifierOffset: -4,
          AlignEscapedNewlines: Left,
          AlignTrailingComments: false,
          AllowAllParametersOfDeclarationOnNextLine: false,
          AllowShortFunctionsOnASingleLine: None,
          BraceWrapping: { AfterFunction: true, AfterNamespace: true },
          BreakBeforeBraces: Custom,
          BreakBeforeInheritanceComma: false,
          BreakBeforeTernaryOperators: false,
          BreakConstructorInitializers: BeforeComma,
          BreakStringLiterals: false,
          CompactNamespaces: false,
          ConstructorInitializerIndentWidth: 8,
          ContinuationIndentWidth: 8,
          Cpp11BracedListStyle: false,
          IndentWidth: 8,
          KeepEmptyLinesAtTheStartOfBlocks: false,
          ObjCBlockIndentWidth: 8,
          ObjCSpaceAfterProperty: true,
                            PenaltyBreakAssignment: 10,
          PenaltyBreakBeforeFirstCallParameter: 30,
                            PenaltyBreakComment: 10,
          PenaltyBreakFirstLessLess: 0,
          ReflowComments: false,
          SortIncludes: false,
          SortUsingDeclarations: false,
          SpacesInContainerLiterals: false,
          Standard: Cpp03,
          UseTab: Always,
                            IndentWidth: 8}" 2>&1
}

clang_format_cpp()
{
  #delete space(s) at the end of line
  sed -i 's/ *$//' $1
  #replace tab to 4 spaces
  sed -i 's/\t/    /g' $1
  #before clang-format, do dos2unix
  dos2unix $1 > /dev/null 2>&1
  #clang-format -i $1 -style=google 2>&1
  clang-format -i $LINES_STR $1 -style="{BasedOnStyle: google,
                              DerivePointerAlignment: false,
            PointerAlignment: Right}" 2>&1
}

json_format()
{
  #delete space(s) at the end of line
  sed -i 's/ *$//' $1
  #replace tab to 4 spaces
  sed -i 's/\t/    /g' $1
  #do dos2unix
  dos2unix $1 > /dev/null 2>&1
}

process_path()
{
  echo "INFO: Start to process directory $1"
  for elem in `ls $1`; do
    local name=$1"/"$elem
    if [ -d $name ]; then
      process_path $name
    else
      process_file $name
    fi
  done
}

process_file()
{
  #get line numbers if incremental mode
  if [[ $FORMAT_MODE == 'INCRE_MODE' ]];then
    #git diff get line numbers
    build_git_line_number_str $1
  fi

  # if no lines for incremental mode, nothing to do
  if [[ $FORMAT_MODE == 'INCRE_MODE' && $LINES_STR == "" ]];then
    echo "WARN: $1 not in repo or no change, nothing to do"
    return
  elif [[ $FORMAT_MODE == 'INCRE_MODE_WITH_LINE_NO' && $LINES_STR == "" ]];then
    echo "WARN: no input numbers, nothing to do on $1"
    return
  fi

  if [ -f $1 ]; then
    echo "INFO: Start to process file $1"
    local filename=$1
    local ext="${filename##*.}"
    if [ $LANG = 'cpp' ] && [ $ext = 'h' -o $ext = 'cpp' -o $ext = 'hpp' ]; then
      echo "INFO: Start to format cpp file:$1"
      clang_format_cpp $1
    elif [ ${LANG} = 'c' ] && [ $ext = 'h' -o $ext = 'c' ]; then
      echo "INFO: Start to format c file:$1"
      clang_format_c $1
    elif [ $ext = 'json' ]; then
      json_format $1
    else
      echo "WARN: $1 is not a desired file"
    fi
  else
    echo "ERROR: process_file needs a file"
  fi
}

is_ready_prerequisites()
{
  if [ -z "$(which dos2unix)" ]; then
    echo "ERROR: install dos2unix firstly please"
    return 1
  fi

  if [ -z "$(which clang-format)" ]; then
    echo "ERROR: install clang-format firstly please"
    return 1
  fi

  return 0
}

calc_file_type()
{
  if [ $1 = 'c' ]; then
    LANG="c"
  elif [ $1 = 'cpp' ]; then
    LANG="cpp"
  elif [ $1 = 'json' ]; then
    LANG="json"
  else
    echo "ERROR: invalid file type and then exit"
    exit 1
  fi
}

do_code_format()
{
  local name=$1
  if [ -f $name ]; then
    process_file $name
  elif [ -d $name ]; then
    process_path $name
  else
    echo "ERROR: $name is not a file or directory."
  fi
}

build_input_line_number_str()
{
  array=(`echo $1 | tr ',' ' '` )
  for var in ${array[@]}
  do
    # get start number
    start=${var%:*}
    # check start number is digit or not
    start_is_num=`is_number $start`
    # get end number
    end=${var#*:}
    # check end number is digit or not
    end_is_num=`is_number $end`
    if [[ -z "$start" || $start_is_num == 0 || -z "$end" || $end_is_num == 0 ]];then
      echo "ERROR: $var is not correct formatting"
      exit 1
    fi
    if [ $start -gt $end ];then
      echo "ERROR: $var start number great than end number"
      exit 1
    fi
    # number start from 1 not 0
    if [ $start -eq 0 ];then
      start=1
    fi
    # build -lines string
    LINES_STR="$LINES_STR -lines $start:$end "
  done
}

build_git_line_number_str()
{
  # reset LINES_STR
  LINES_STR=""
  # get git diff lines
  array=(`git diff -U0 $1 | grep -o "^@@.*@@" | grep -o "\+.* " | sed 's/^.//'` )
  for var in ${array[@]}
  do
    start=${var%,*}
    if [[ $var =~ "," ]];then
      # mutil lines modify or add
      # e.g. # @@ -4,9 +4,9 @@
      count=${var#*,}
      count_is_num=`is_number $end`
    else
      # single line modify
      # e.g. @@ -15 +15 @@
      count=1
      count_is_num=1
    fi
    if [[ $count -eq 0 ]];then
      # delete line
      # e.g. @@ -15 +15,0 @@
      continue
    fi
    if [[ $count_is_num == 0 ]];then
      end=$start
    else
      end=$[$start+$count-1]
    fi
    LINES_STR="$LINES_STR -lines $start:$end "
  done
}

is_number()
{
  expr $1 "+" 10 &> /dev/null
  if [ $? -eq 0 ];then
    echo 1
  else
    echo 0
  fi
}

#main function
if [ $# -lt 1 ]; then
  usage
fi

if ! is_ready_prerequisites; then
  echo "ERROR: `basename $0` needs some prerequisite tools"
  exit 1
fi

while getopts h:l:i:n: argvs; do
  case $argvs in
  l) FORMAT_MODE="FULL_MODE"
    calc_file_type ${OPTARG}
    ;;
  i) FORMAT_MODE="INCRE_MODE"
    calc_file_type ${OPTARG}
    ;;
  n) FORMAT_MODE="INCRE_MODE_WITH_LINE_NO"
    calc_file_type ${OPTARG}
    ;;
  h) usage;;
  ?) usage;;
  esac
done
shift $((OPTIND - 1))

#run the rest of files or directories
while [ $# != 0 ]; do
  if [[ $FORMAT_MODE == "INCRE_MODE_WITH_LINE_NO" ]];then
    if [ $# -lt 2 ]; then
      echo "ERROR: missing start and end line numbers"
      exit 1
    fi
    build_input_line_number_str $2
    do_code_format $1
    shift 2
  else
    do_code_format $1
    shift
  fi
done

exit 0
