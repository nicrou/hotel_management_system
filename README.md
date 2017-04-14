# README

## About

Hotel Management System is a web application I developed that offers a suite of tools for managing the reservations and other data for a hotel business.

The user just needs to describe his/her infrastucrure using the UI.

Data visualization tools like timetables for reservations and various charts measuring several aspects of such business will keep track of everything else and display it.

In addition the system includes several custom CMS features so the user can easily manage his/her own files, design responsive customized themes for the site and create multilingual content all in a matter of a few minutes.</br>

## Installation

The installation/deployment process is quite straightforward; pretty much the same process one would go through for any other rails app.
Just to highlight a few points:

The database server need to be set up with UTF8 encoding otherwise you won't be able to save content containing non-english characters. That is quite important to take into consideration since I think at least mariaDB and/or MySQL server usually have Latin1 as default.

Personally I am using mariaDB server but it will work with MySQL without any modifications.

Using postgreSQL instead requires adding the appropriate gem and modifying the database.yml accordingly.
In order to migrate to postgreSQL later on there are some instructions on <a target="_blank" href="https://devcenter.heroku.com/articles/heroku-mysql">this</a> heroku article.

Furthermore at least one user/profile must be added. This should be done directly for the first user and set the flags <b>approved</b> for Devise User model and <b>admin</b> for it's Profile nested model manually. That needs to be done because the application's user registration is configured to require administration approval; thus a new user (employee/manager) account cannot be activated unless there is already an admin to approve it but even an admin account cannot log in unless that user is already approved/activated.

I assume you can add it to seeds and avoid this slight hassle but I did not bother so there is that. </br></br>

And that's it. Now just log in and create some content.

Notice that navigating to the hotel url while there isn't any content naturally will result in 404 errors.

## Usage

Other than navigating around the site and its content ( keep in mind that the site was created in about 15 minutes using only the provided tools ) you can also test reservations by creating some dummy bookings as a customer, to do that click on the <b>book now</b> link.<br><br>

Notice <b> <i class="glyphicon glyphicon-user"></i> Sign Up</b> | <b><i class="glyphicon glyphicon-log-in"></i> Log In</b> buttons on the right side of the navbar. These exist only for this demo's purposes.

Log in as an employee and test the administrator interface. There is also a manager role with deletion provileges.

New users will need approval from an admin account and since I won't be monitoring this there is no point signing up so just log in as a test user I have set up using these credentials mail: <b>test_user@demo.com</b> and password: <b>p4$$w0rD</b>

After you log in you can test most of the administration interface and it's functionalities.

<h5><b>Just please do so responsibly and try not to break the demo so other people can use it as well. </b></h5></br>

I originally used dummy data for bookings that are dated back in February/March 2017.
Thus unless some user has deleted them while testing the demo, you should either visit those months in order to check out the charts, timetables etc. or create some new, current data, yourself. <br><br>

Lastly it would be much appreciated it you could report to me any bugs you may find since this entire project was built in such a short time and I haven't extensively tested it.

## Considerations

<i class="fa fa-info-circle text-info"></i> One issue you may notice is some significant loading overhead which is caused due to the number of libraries I am including in the head that are used for the administration interface's functionalities. I did not try any workarounds (like loading scripts on specific pages) or any other action to counter that issue because</br>
    a. the asset pipeline kinda makes up for it after the first load so, performance wise, it is not that bad afterwards and more importantly</br>
    b. this whole setup was meant as a demo and it would be a better practice to deploy the administration inteface in another location entirely, preferably as a special sub-domain such as admin.hotelname.com and make it a separate application, which is also recommended as per rails documentation regarding security.
    So that would also fix the initial issue as well. The hotel site by itself uses very few libraries and scripts. This transition is actually pretty easy, it only needs a couple modifications that includes moving one controller and its respective views to the new application project and make sure the javascript files that are needed are also included.</br></br>

<i class="fa fa-info-circle text-info"></i> Localization/ Internalization: This project does not follow suit with rails Internationalization (I18n) API. Instead the site will pick the languages of any content flagged as <b>index</b> and make them available for selection.

When the user changes to one of these languages the project will pick any content marked with the selected language and built the localized site. Thus you can even built entirely different experiences for your various locales.

That being said to localize shared parts of the site, for example the footer, the locales yml should be used as normally assuming that the languages which are going to be used have been decided already.

Notice that there were no plans about localizing the administration interface so that is just english.

Regarding the bookings since the data of each category is created by the system's user dynamically and saved to the database none of these would work so if that part needs to be localized a custom approach would be needed.

<i class="fa fa-info-circle text-info"></i> CMS index "feature". Yeah this is just me not having enough time to develop a decent positioning approach.

Anyways I want at some point to create a custom CMS engine ( yeah another one ) from scratch based on some stuff here and if that comes to pass I will try to tackle this issue in a more appropriate way and update this project.

Until then please look the other way and remember the higher the index the higher it will appear on the page.

## Known Bugs

<i class="fa fa-bug text-warning"></i> This one is not an actual bug but I should at least notify you. There are some help buttons throughout the administration panels not working. Well that is because I actually forgot to implement them at all XD. I wanted to make some popups with instuctions but at the time I got bored and moved on, then I forgot entirely about it and finally deployed. Now that I noticed it I don't feel motivated to write these how-to-use tips for the demo so just ignore them.</br></br>

<i class="fa fa-bug text-warning"></i> There is a possible buggy behaviour occuring with some javascript plugins not loading properly when using browser's back and/or forward buttons but I haven't replicated this one consistently yet so I am not sure as to why that is happening. I am assuming it has something to do with turbolinks or maybe caching but I haven't looked much into it and I am not even sure it wasn't a specific browser issue.

## Gems & Plugins
This a list of all the additional gems I am using.

<ul class="text-left">
      <li><a target="_blank" href="https://rubygems.org/gems/devise"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/plataformatec/devise"><i class="fa fa-github"></i></a> devise</li>
      <li><a target="_blank" href="https://rubygems.org/gems/country_select"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/rails/country_select"><i class="fa fa-github"></i></a> rails/country_select</li>
      <li><a target="_blank" href="https://rubygems.org/gems/momentjs-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/derekprior/momentjs-rails"><i class="fa fa-github"></i></a> momentjs-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/pick-a-color-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/jkaipr/pick-a-color-rails"><i class="fa fa-github"></i></a> pick-a-color-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/tiny-color-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/jkaipr/tiny-color-rails"><i class="fa fa-github"></i></a> tiny-color-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/animate-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/camelmasa/animate-rails"><i class="fa fa-github"></i></a> animate-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap-switch-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/manuelvanrijn/bootstrap-switch-rails"><i class="fa fa-github"></i></a> bootstrap-switch-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap-select-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/silviomoreto/bootstrap-select"><i class="fa fa-github"></i></a> bootstrap-select</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap-select-wrapper-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/TheDonDope/bootstrap-select-wrapper-rails"><i class="fa fa-github"></i></a> bootstrap-select-wrapper-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap-table-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/bjevanchiu/bootstrap-table-rails"><i class="fa fa-github"></i></a> bootstrap-table-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap-datepicker-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/Nerian/bootstrap-datepicker-rails"><i class="fa fa-github"></i></a> bootstrap-datepicker-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap_tokenfield_rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/icicletech/bootstrap-tokenfield-rails"><i class="fa fa-github"></i></a> bootstrap-tokenfield-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/bootstrap-wysihtml5-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/Nerian/bootstrap-wysihtml5-rails"><i class="fa fa-github"></i></a> bootstrap-wysihtml5-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/font-awesome-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/bokmann/font-awesome-rails"><i class="fa fa-github"></i></a> font-awesome-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/money-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/RubyMoney/money-rails"><i class="fa fa-github"></i></a> money-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/owl_carousel-rails"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/nicrou/owl_carousel-rails"><i class="fa fa-github"></i></a> owl_carousel-rails</li>
      <li><a target="_blank" href="https://rubygems.org/gems/chartjs-ror"><i class="fa fa-diamond"></i></a> <a target="_blank" href="https://github.com/airblade/chartjs-ror"><i class="fa fa-github"></i></a> chartjs-ror</li>
    </ul>

 ## Cross Browser Compatibility
To be honest I have barely tested it for cross-browser compatibility but I am assuming it works in
    most modern browsers while it probably won't work properly on zombie browsers.
    The development was done with firefox developer 53.0 and firefox 51.0. I also did some
    light testing with Chromium 55.0 and 0pera 42.0 which both seemed to work alright and that's about it.
    I suppose it boils down to the various libraries I am using so if any of these does not work with some browser's versions it will naturally extend to this project.

## Contact
For any questions you may have you can contact me at <a href="mailto:info@nickthegeek.gr">info@nickthegeek.gr</a>
