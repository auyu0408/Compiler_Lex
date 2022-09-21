# Compiler Homework

This is the repository for Comppiler 2022, in NCKU

## Hw1
In hw1, we need to implement a scanner using flex. And we will use [`local-judge`](https://github.com/aben20807/local-judge) to test the program by ourselves.  

### Environmental Setup
For Linux: Ubuntu 18.04 LTS or up

Install dependencies:
```
$sudo apt-get install flex bison git python3 python3-pip
```

Get Judger:
```
pip3 install local-judge
```

### Directories
- README.md: This file
- compiler_hw1.l : scanner's man source, written by lexical definitions 
- judge.conf : Config file of the local-judge
- input/ : Input test cases prepared by TAs 
- answer/ : Input's correct answer

### Build the Project
- Build the scanner
```
make
```
Then you will get the target `myscanner`  

- Test your scanner
```
make judge
```
It will build `myscanner` and call local judge  

- delete the scanner
```
make clean
```

- If you have input file prepare by yourselves:
```
./myscanner < [inputfilename] > [outputfilename]
```

### Reference
[the online manual for Lex](http://dinosaur.compilertools.net/lex/index.html)  
[kvnyijia /CC_Lex](https://github.com/kvnyijia/CC_Lex) (Thank you for your C Comment QQ)