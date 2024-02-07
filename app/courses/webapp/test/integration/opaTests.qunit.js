sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'courses/test/integration/FirstJourney',
		'courses/test/integration/pages/CoursesList',
		'courses/test/integration/pages/CoursesObjectPage',
		'courses/test/integration/pages/Courses_BooksObjectPage'
    ],
    function(JourneyRunner, opaJourney, CoursesList, CoursesObjectPage, Courses_BooksObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('courses') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheCoursesList: CoursesList,
					onTheCoursesObjectPage: CoursesObjectPage,
					onTheCourses_BooksObjectPage: Courses_BooksObjectPage
                }
            },
            opaJourney.run
        );
    }
);