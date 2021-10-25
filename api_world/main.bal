import ballerina/http;

type Student record {
    string Name;
    int[] Grades;
};

service / on new http:Listener(9090) {

    // This alone
    resource function get sayHello() returns string {
        return "Hello!";
    }

    // Path param
    resource function get hello/[string name]() returns string {
        return string `Hello ${name.toUpperAscii()}`;
    }

    // localhost:9090/queryPramToJson?name=Jane&id=443948333
    resource function get queryPramToJson(string name, string id) returns json {
        return {user_name: name, id};
    }

    // Query param, for a long list of query objects
    // localhost:9090/queryParamObject?name=Jane
    resource function get queryParamObject(http:Request req) returns json {
        map<string[]> qParams = req.getQueryParams();
        string[]? name = qParams["name"];
        if name == () {
            return "No query param found with name=name";
        }
        else {
            return "Hello " + name[0];
        }
    }

    // `val` extracted from http header.
    resource function get header(@http:Header string? val) returns json {
        return {value: val};
    }

    resource function post jsonEcho(@http:Payload json j) returns json => j;

    // Json structure similar to { "Name": "Miranda", "Grades": [65, 99, 88] } will be mapped to `Student` type.
    resource function post bumpGrades(@http:Payload Student student) returns json {
        string name = student.Name;
        int[] newGrades = student.Grades.map((i) => int:min(i + 10, 100));
        int sum = 0;
        foreach var i in newGrades {
            sum += i;
        }
        int avg = sum / newGrades.length();

        return {Name: name, Grades: newGrades, Average: avg};
    }

    resource function post extractCity(@http:Payload xml store) returns xml {
        // Extract a descendent element from a xml value.
        xml city = store/**/<city>;
        return city;
    }

    // For any advance use case, we can use the http:Response object and manually 
    // all the content as we wish.
    // Let's generate html pages using ballerina xml type.
    resource function get html() returns @http:Payload {mediaType: "text/html"} xml {
        xml header = xml `<head><title>Hello from Ballerina</title></head>`;
        xml body = xml `<body>
        <h1>Howdy</h1>
        <p>In ballerina we use xml type to generate html.</p>
        <p>It's just easier than using plain string concatenation.</p>
        </body>`;
        xml html = xml `<html>${header}${body}</html>`;
        return html;
    }
}
