/**
 * Builds token DFAs.
 * 
 * @author Christian Wendlandt
 * @version 2018.2.16
 */

import java.util.List;
import java.util.Arrays;
import java.nio.charset.Charset;
import java.nio.file.*;
import java.io.IOException;
import java.util.ArrayList;

public class tokenWriter
{
    public static void main(String[] args)
    {
        ArrayList<String> tokenNames = new ArrayList<>(Arrays.asList(
                "String",
                "Print",
                "Bool",
                "Class",
                "Else",
                "Extends",
                "False",
                "If",
                "Int",
                "Length",
                "Main",
                "New",
                "Public",
                "Return",
                "Static",
                "This",
                "True",
                "Void",
                "While",
                "Lbracket",
                "Lcurly",
                "Lparen",
                "Rbracket",
                "Rcurly",
                "Rparen",
                "And",
                "Comma",
                "Equal",
                "Lt",
                "Minus",
                "Exc",
                "Period",
                "Plus",
                "Semicolon",
                "Times"
                ));
        ArrayList<String> tokens = new ArrayList<>(Arrays.asList(
                "String",
                "System.out.println",
                "boolean",
                "class",
                "else",
                "extends",
                "false",
                "if",
                "int",
                "length",
                "main",
                "new",
                "public",
                "return",
                "static",
                "this",
                "true",
                "void",
                "while",
                "[",
                "{",
                "(",
                "]",
                "}",
                ")",
                "&&",
                ",",
                "=",
                "<",
                "-",
                "!",
                ".",
                "+",
                ";",
                "*"
                ));
        ArrayList<String> lines;
        
        for(int i = 0; i < tokenNames.size(); i++)
        {
            lines = new ArrayList<>();
            lines.addAll(Arrays.asList(
                    "/**",
                    " * DFA for T" + tokenNames.get(i) + ".",
                    " *",
                    " * @author Christian Wendlandt",
                    " * @version 2018.2.16",
                    " */",
                    "public class T" + tokenNames.get(i) + " extends DFA",
                    "{",
                    "    public T" + tokenNames.get(i) + "()",
                    "    {",
                    "        code = \"<T" + tokenNames.get(i) + ">\";",
                    "    }",
                    "",
                    "    public int offer(char character)",
                    "    {",
                    "        switch(state)",
                    "        {"
                    ));
            for(int j = 0; j < tokens.get(i).length() - 1; j++)
            {
                lines.addAll(Arrays.asList(
                        "            case " + j + ":",
                        "                if(character == '" + tokens.get(i).charAt(j) + "')",
                        "                {",
                        "                    state = " + (j + 1) + ";",
                        "                    return DFAManager.OK;",
                        "                }",
                        "                state = -1;",
                        "                break;"
                        ));
            }   
            lines.addAll(Arrays.asList(
                    "            case " + (tokens.get(i).length() - 1) + ":",
                    "                state = -1;",
                    "                if(character == '" + tokens.get(i).charAt(tokens.get(i).length() - 1) + "')",
                    "                    return DFAManager.ACCEPT;",
                    "        }",
                    "        return DFAManager.REJECT;",
                    "    }",
                    "}"
                    ));
            Path file = Paths.get("T" + tokenNames.get(i) + ".java");
            try
            {
                Files.write(file, lines, Charset.forName("UTF-8"));
            }
            catch(IOException ex)
            {
                System.out.println(ex.getMessage());
            }
        }
    }
}