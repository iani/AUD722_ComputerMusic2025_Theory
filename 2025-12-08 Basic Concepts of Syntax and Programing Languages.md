
Here’s a compact, concept-first introduction to **programming language syntax and semantics**, with the key terms you asked for—focused on how languages are _defined_ and how _compilers_ work.

---

## 1. Syntax vs. Semantics (the core distinction)

### **Syntax**

- The **form** of a program.
    
- It answers: _Is this program written correctly according to the rules of the language?_
    
- Example:
    
    ```c
    x = 3 + ;
    ```
    
    This is **syntactically invalid** (a `+` must have something after it).
    

### **Semantics**

- The **meaning** of a program.
    
- It answers: _What does this program actually do when it runs?_
    
- Example:
    
    ```c
    x = 3 / 0;
    ```
    
    This is **syntactically valid** but **semantically problematic** (division by zero).
    

> **Short rule:**  
> **Syntax = structure, Semantics = meaning.**

---

## 2. Tokens, Identifiers, and Separators (Lexical Level)

Before parsing syntax, a compiler first breaks raw text into **tokens**. This stage is called **lexical analysis**.

### **Token**

A **token** is the smallest meaningful unit recognized by the compiler.

Examples of token types:

- Keywords: `if`, `while`, `return`
    
- Identifiers: `x`, `totalSum`
    
- Operators: `+`, `==`, `*`
    
- Literals: `42`, `"hello"`
    
- Separators: `(`, `)`, `{`, `;`
    

Example:

```c
int x = 10;
```

is tokenized as:

```
[int] [x] [=] [10] [;]
```

---

### **Identifier**

An **identifier** is a name given to something:

- variable names
    
- function names
    
- class names
    

Examples:

```c
count
main
AudioBuffer
```

Typical rules for identifiers:

- Must start with a letter or `_`
    
- Can contain letters, digits, `_`
    
- Cannot be a reserved keyword (`if`, `for`, etc.)
    

---

### **Separator (Delimiter)**

A **separator** is a symbol used to **structure code**.

Common separators:

- `(` `)` → grouping, function calls
    
- `{` `}` → blocks
    
- `,` → argument separation
    
- `;` → statement termination
    

They don’t carry meaning by themselves, but they **shape the syntax**.

---

## 3. Backus–Naur Form (BNF): How Syntax Is Formally Defined

**Backus–Naur Form (BNF)** is a **formal mathematical notation** used to describe the **grammar** of a programming language.

It defines:

- What counts as a valid statement
    
- How expressions can be built recursively
    

### Basic Structure of BNF

```
<symbol> ::= definition
```

Example (simple arithmetic):

```
<expression> ::= <term> | <expression> "+" <term>
<term>       ::= <number> | "(" <expression> ")"
<number>     ::= digit | digit <number>
```

This means:

- An `expression` can be a `term`
    
- Or an `expression + term`
    
- A `term` can be a number or a parenthesized expression
    

BNF is used in:

- Language specifications
    
- Parser design
    
- Compiler construction
    

---

## 4. Parsing: From Tokens to Structure

After tokenization comes **parsing**.

### **Parsing**

- The process of turning a flat token stream into a **tree structure** called a **parse tree** or **abstract syntax tree (AST)**.
    
- It checks whether the token sequence follows the **grammar (BNF rules)**.
    

Example:

```c
x = 3 + 4;
```

After parsing, this becomes a structured tree like:

```
    =
   / \
  x   +
     / \
    3   4
```

This structure is what later stages use for:

- Type checking
    
- Optimization
    
- Code generation
    

---

## 5. Where Syntax & Semantics Fit in a Compiler

A simplified compiler pipeline:

1. **Lexical analysis**  
    → characters → **tokens**
    
2. **Parsing (Syntax Analysis)**  
    → tokens → **syntax tree (AST)**  
    → checks **syntactic correctness**
    
3. **Semantic analysis**  
    → checks meaning:
    
    - Are variables declared?
        
    - Are types compatible?
        
    - Are functions called correctly?
        
4. **Optimization**  
    → improves performance
    
5. **Code generation**  
    → outputs machine code or bytecode
    

---

## 6. One-Sentence Definitions (Quick Reference)

- **Syntax**: The formal structure of valid programs.
    
- **Semantics**: The meaning or behavior of those programs.
    
- **Token**: The smallest meaningful unit of source code.
    
- **Identifier**: A user-defined name for a program element.
    
- **Separator**: A symbol that structures code (e.g., `;`, `{}`).
    
- **Backus–Naur Form (BNF)**: A formal notation for defining programming language grammar.
    
- **Parsing**: The process of converting tokens into a structured syntax tree.
    

---

If you’d like, I can also give:

- A visual diagram of tokenizer → parser → semantic analyzer
    
- Or relate this directly to **SuperCollider / sclang** syntax and parsing.

---

# Delimiter

These character items are collectively called **delimiters, operators, and lexical markers** depending on their function. In compiler and language theory, they fall under the broader category of **tokens**, but more precisely they are classified as follows:

---

## 1. **Delimiters** (a.k.a. Demarcators)

These **enclose or separate** structured objects.

### Examples:

- **String delimiters**:
    
    - `"hello"` → `"` are string delimiters
        
    - `'a'` → `'` are character delimiters
        
- **Grouping delimiters**:
    
    - `( )`, `{ }`, `[ ]`
        
- **Separators**:
    
    - `,` (argument separator)
        
    - `;` (statement terminator)
        

➡ These mark **boundaries of objects**.

---

## 2. **Operators**

These **act on values** and define relationships.

### Your examples:

- **Negative sign**:
    
    - `-5` → unary **minus operator**
        
- **Arithmetic operators**:
    
    - `+ - * /`
        
- **Comparison operators**:
    
    - `== < >`
        

➡ Operators express **actions or relations**, not boundaries.

---

## 3. **Lexical Markers / Punctuation Tokens**

This is the most general technical term that includes:

- Delimiters
    
- Operators
    
- Special symbols that guide parsing
    

Examples:

- `.` → **decimal point marker** in `3.14`
    
- `:` → type annotation or key-value binding
    
- `::` → scope resolution (C++, Scala)
    
- `->` → mapping, lambda, pointer member access
    

➡ These don’t “compute” by themselves but **signal grammatical roles**.

---

## 4. How your specific examples are named

|Character|Function|Correct Term|
|---|---|---|
|`"`|marks a string|**String delimiter**|
|`'`|marks char or symbol|**Character/Symbol delimiter**|
|`.`|marks floating point|**Decimal point / radix point**|
|`-` (as in `-3`)|negative sign|**Unary minus operator**|

---

## 5. Unifying term (what you probably want)

If you want **one umbrella term** that is correct in compiler theory:

> ✅ **Punctuation tokens**  
> ✅ **Lexical operators and delimiters**  
> ✅ Most rigorously: **Non-alphanumeric tokens**

And at the highest level:

> ✅ **They are all _tokens_ produced by the lexer.**

---

### Compact answer in one line

**They are called _lexical punctuation tokens_, subdivided into _delimiters_ (for strings and grouping), _operators_ (for `-`), and _radix-point markers_ (for `.` in floats).**

If you want, I can also map these categories to how they are handled in real lexer implementations (regular expressions, token priority, ambiguity resolution).