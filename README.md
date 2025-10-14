 # 🧠 Pascal-Like Compiler Project

This project is a *mini compiler* designed for a Pascal-like programming language.  
It performs *lexical, **syntactic, and basic **semantic* analysis using *LEX* and *YACC*.

---

## 📁 Project Files
| File | Description |
|------|--------------|
| lexer.l | Lexical analyzer — defines tokens such as identifiers, keywords, numbers, and symbols. |
| parser.y | Syntax analyzer — defines grammar rules and parsing logic. |
| grammar.txt | Contains the original grammar specification used to build the parser. |
| test.pas | Sample Pascal-like program for testing the compiler. |
| compiler project.pdf | Project documentation — explains design, grammar, and implementation details. |

---

## 🚀 Features
- Lexical analysis using *LEX*
- Syntax analysis using *YACC*
- Symbol table management (identifiers, data types, and scope)
- Error handling for invalid tokens or syntax errors
- Support for:
  - Variable declarations  
  - Assignments  
  - Arithmetic & logical expressions  
  - Conditional statements (if, else)  
  - Compound statements (begin ... end)

---

## ⚙️ How to Compile and Run
1. Open your terminal inside the project directory.
2. Run the following commands:

```bash
lex lexer.l
yacc -d parser.y
gcc lex.yy.c y.tab.c -o compiler
./compiler < test.pas






