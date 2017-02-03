package tools.sql.entity;

import tools.sql.utils.Annot;
import tools.sql.utils.Utilities;

import java.util.HashSet;
import java.util.Set;

public class JColumn {

    private Set<Annot> annotations = new HashSet<>();
    private final String name;
    private final String type;

    public JColumn(String name, String type) {
        this.name = name;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public String toJava() {
        StringBuilder res = new StringBuilder();
        for (Annot annotation : annotations) {
            res.append("\t@");
            res.append(annotation.getName());
            res.append(";\n");
        }
        res.append("\tprivate " + type + " " + name + ";\n");
        return res.toString();
    }

    public String toJavaImports() {
        StringBuilder sb = new StringBuilder();
        for (Annot annotation : annotations) {
            sb.append("import ");
            sb.append(annotation.getPack());
            sb.append(".");
            sb.append(annotation.getName());
            sb.append(";\n");
        }
        return sb.toString();
    }

    public String toJavaGetterSetter() {
        StringBuilder res = new StringBuilder();

        res.append("\tpublic " + type + " get" + Utilities.capitalize(name) + "() { return " + name + "; }\n" + "\tpublic void set" + Utilities.capitalize(name) + "(" + type + " " + name + ") { this." + name + " = " + name + "; }\n");
        return res.toString();
    }

    public void addAnnot(Annot a) {
        annotations.add(a);
    }

}
