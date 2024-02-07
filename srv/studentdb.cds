using { com.madhu.studentdb as db} from '../db/schema';


service StudentDB {
    entity Student as projection on db.Student;
    entity Gender as projection on db.Gender;
    entity Books as projection on db.Books
    {
        @UI.Hidden:true
        ID,
        *
    };
  entity Courses as projection on db.Courses {
        @UI.Hidden: true
        ID,
        *
    };

}
//function GetBooksByCourseCode(courseCode: String) returns [Books];

annotate StudentDB.Student with @odata.draft.enabled;
annotate StudentDB.Courses with @odata.draft.enabled;
annotate StudentDB.Books with @odata.draft.enabled;

//annotate StudentDB.Books with @odata.draft.enabled;



annotate StudentDB.Student with {
    first_name      @assert.format: '^[a-zA-Z]{2,}$';
    last_name      @assert.format: '^[a-zA-Z]{2,}$';    
    email_id     @assert.format: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
     pan     @assert.format: '^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
    //telephone @assert.format: '^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
}

annotate StudentDB.Courses with @(
    UI.LineItem:[
        {
            Value: code
        },
        {
            Value: description
        },{
            Label : 'Course Books ',
            Value : Books.book.description
        },
    ],
     UI.FieldGroup #CourseInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                Value : code,
            },
            {
                Value : description,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'StudentInfoFacet',
            Label : 'Student Information',
            Target : '@UI.FieldGroup#CourseInformation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'CourseBookFacet',
            Label : 'Course Books',
            Target : 'Books/@UI.LineItem',
        },
    ],
   

);




annotate StudentDB.Gender with @(
    UI.LineItem:[
        {
            @Type: 'UI.DataField',
            Value: code
        },
        {
            @Type: 'UI.DataField',
            Value: description
        },
    ]
);

annotate StudentDB.Courses.Books with @(
 UI.LineItem: [
        {
            Label: 'Books',
            Value : book_ID
        },
 ],
 UI.FieldGroup #CourseBooks : {
    $Type : 'UI.FieldGroupType',
    Data : [
        {
            Value :book_ID
        }
    ],
 },
 UI.Facets : [
    {
        $Type :'UI.ReferenceFacet',
        ID : 'CourseBooksFacet',
        Label : 'CourseBooks',
        Target : '@UI.FieldGroup#CourseBooks',
    },
 ],
);

annotate StudentDB.Books with @(
    UI.LineItem:[
        {
            Value: code
        },
        {
            Value: description
        }
    ],
    UI.FieldGroup #Books :{
        $Type : 'UI.FieldGroupType',
        Data :[
            {
                Value : code,
            },
            {
                Value : description
            }
        ]
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'BooksFacet',
            Label : 'Books',
            Target : '@UI.FieldGroup#Books'
        }
    ]
);



annotate StudentDB.Student with @(
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : studentid
        },
        
        {
            $Type : 'UI.DataField',
            Label: 'Gender',
            Value : gender
        },
        
        {
            $Type : 'UI.DataField',
            Value : first_name
        },
        {
            $Type : 'UI.DataField',
            Value : last_name
        },
        {
            $Type : 'UI.DataField',
            Value : email_id
        },
              {
            $Type : 'UI.DataField',
            Value : dob
        },
         {
            $Type : 'UI.DataField',
            Value : pan
        },
        {
            Value: course.code
        },
        {
            $Type: 'UI.DataField',
            Label: 'Book Title',
            Value: book.code
        }


    ],
    UI.SelectionFields: [ first_name , last_name, email_id],       
);

annotate StudentDB.Student with @(
    UI.FieldGroup #StudentInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : studentid,
            },
            {
                $Type : 'UI.DataField',
              //  Label: 'Gender',
                Value : first_name,
            },
            {
                $Type : 'UI.DataField',
                Value : last_name,
            },
            {
                $Type : 'UI.DataField',
                Value : gender,
            },
            {
                $Type : 'UI.DataField',
                Value : email_id,
            },
            {
                $Type : 'UI.DataField',
                Value : dob,
            },
            {
                $Type : 'UI.DataField',
                Value : pan,
            },
            {
                $Type: 'UI.DataField',
                Value: course_ID
            },{
                $Type: 'UI.DataField',
                Value: book_ID
            }
            
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'StudentInfoFacet',
            Label : 'Student Information',
            Target : '@UI.FieldGroup#StudentInformation',
        },
    ],
    
);
annotate StudentDB.Courses.Books with {
    book @(
        Common.Text: book.code,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Books',
            CollectionPath : 'Books',
            Parameters: [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : book_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'code'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                },
            ]
        }
    );
};

annotate StudentDB.Student with {
    gender @(
        Common.ValueListWithFixedValues:true,
        Common.ValueList: {
            Label :'Genders',
            CollectionPath:'Gender',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty:gender,
                    ValueListProperty:'code'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty:'description'
                }

            ]
        }
    );
    course @(
        Common.Text: course.description,
        Common.TextArrangement: #TextOnly,
        Common.ValueListWithFixedValues: true,
        Common.ValueList : {
            Label: 'Courses',
            CollectionPath : 'Courses',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : course_ID,
                    ValueListProperty : 'ID'
                },
               
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'code'
                },
                   {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                }
            ]
        }
    )
}
