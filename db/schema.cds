namespace com.madhu.studentdb;
using { managed, cuid } from '@sap/cds/common';

@assert.unique:{
    studentid:[studentid]
}
entity Student: cuid, managed {
    @title: 'Student ID'
    studentid: String(5);
    @title: 'Gender'
    gender: String(1);
    @title: 'First Name'
    first_name: String(40) @mandatory;
    @title: 'Last Name'
    last_name: String(40) @mandatory;
    @title: 'Email ID'
    email_id: String(100) @mandatory;
    @title: 'Date of Birth'
    dob: Date @mandatory;
    @title:'Pan'
    pan:String(11);
    @title: 'Course'
    course: Association to Courses;
    @title: 'Age'
    virtual age: Integer @Core.Computed;
    // New field related to books
    @title: 'Book'
    book: Association to Books;
      @title: 'Is Alumni'
    is_alumni: Boolean default false;
}

@cds.persistence.skip
entity Gender {
    @title: 'code'
    key code: String(1);
    @title: 'Description'
    description: String(10);
}


entity Courses : cuid, managed {
    @title: 'Code'
    code: String(3);
    @title: 'Description'
    description: String(50);
    Books : Composition of many{
        key ID: UUID;
       book :Association to Books;
    }

}

entity Books : cuid,managed{
    @title:'Code'
    code:String(3);
    @title:'Description'
    description:String(20);
}


