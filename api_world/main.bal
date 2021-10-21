import ballerina/http;

type Student record {
    string Name;
    int Grade;
};

service / on new http:Listener(9090) {

    resource function post bindStudent(@http:Payload Student student)
            returns json {
        string name = student.Name;
        return {Name: name};
    }

    resource function post bindXML(@http:Payload xml store) returns xml {
        xml city = store/**/<city>;
        return city;
    }

    resource function get qparam/[string p]/[string q]() returns json {
        return {
            p,
            q
        };
    }

    resource function get header(@http:Header string? val) returns json {
        return {value: val};
    }

    resource function default . (http:Request req) returns xml|error {
        string header = check req.getHeader("val");
        return xml `<header>${header}</header>`;
    }
}
