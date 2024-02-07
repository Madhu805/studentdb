const cds = require('@sap/cds');
/*module.exports = srv => {
    srv.on('GetBooksByCourseCode', async req => {
        const { courseCode } = req.data;
        const books = await srv.transaction(req).run(SELECT.from(Books).where({ 'course.code': courseCode }));
        return books;
    });
};*/


function calcAge(dob){
    var today = new Date();
    var birthDate = new Date(Date.parse(dob));    
    var age = today.getFullYear() - birthDate.getFullYear();
    var m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }
    return age;
}

module.exports = cds.service.impl(function () {

    const { Student, Gender } = this.entities();

    this.on(['READ'], Student, async(req) => {
        results = await cds.run(req.query);
        if(Array.isArray(results)){
            results.forEach(element => {
             element.age=calcAge(element.dob); 
            });
        }else{
            results.age=calcAge(results.dob);
        }
        
        return results;
    });



    this.before(['CREATE'], Student, async(req) => {
        age = calcAge(req.data.dob);
        if (age<18 || age>45){
            req.error({'code': 'WRONGDOB',message:'Student not the right age for school:'+age, target:'dob'});
        }

        let query1 = SELECT.from(Student).where({ref:["email_id"]}, "=", {val: req.data.email_id});
        result = await cds.run(query1);
        if (result.length >0) {
            req.error({'code': 'STEMAILEXISTS',message:'Student with such email already exists', target: 'email_id'});
        }

    });

    this.before(['UPDATE'], Student, async(req) => {
        age = calcAge(req.data.dob);
        if (age<18 || age>45){
            req.error({'code': 'WRONGDOB',message:'Student not the right age for school:'+age, target:'dob'});
        }

        let query1 = SELECT.from(Student).where({ref:["email_id"]}, "=", {val: req.data.email_id}).where({ref:["ID"]}, "!=", {val: req.data.ID});
        result = await cds.run(query1);
        if (result.length >0) {
            req.error({'code': 'STEMAILEXISTS',message:'Student with such email already exists', target: 'email_id'});
        }

    });
    
    this.on('READ', Gender, async(req) => {
        genders = [
            {"code":"M", "description":"Male"},
            {"code":"F", "description":"Female"}
        ]
        genders.$count=genders.length;
        return genders;
    })
    

});