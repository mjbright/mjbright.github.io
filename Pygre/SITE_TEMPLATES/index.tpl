<!DOCTYPE html>
<html lang="en">
{% include 'head.tpl' %}
  <body>

    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#"> Groupe d'Utilisateurs Python Grenoble </a>
          <div class="nav-collapse collapse">
            <!--
            <p class="navbar-text pull-right">
              Logged in as <a href="#" class="navbar-link">Username</a>
            </p>
              <ul class="nav">
                <li class="active"><a href="#">Home</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#contact">Contact</a></li>
              </ul>
            -->
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container-fluid">
      <div class="row-fluid">
{% include 'sidebar.tpl' %}
        <div class="span9">
          <div class="hero-unit">
           <img src="images/grenoble-pont-st-laurent.png">

            <!-- <h1>Python User Group de Grenoble</h1> -->
            <h1> Groupe d'Utilisateurs Python Grenoble </h1>
            <p>Nous sommes une groupe de personnes qui se reunit chaque mois depuis 2014 pour parler Python et tout ce qui est autour.  Nous ne sommes pas une association, nous profitons des lieux de la Casemate a Grenoble pour nos reunions.
    <h2> La Casemate </h2>
        <a href="http://www.ccsti-grenoble.org/" >
          <img src="https://mw2.google.com/mw-panoramio/photos/medium/7776150.jpg" />
        </a>

    <hr/> <br/>

    <h3> Suivez-nous sur
     <p>
        <a href="https://twitter.com/PyUGGre">
          <img width=50 src="images/Twitter_logo_blue.png">
          Twitter: @PyUGGre
        </a>
      [ <a href="https://twitter.com/search?q=PyUGGre&src=typd"> tweets </a> ]
     </p>
    <p>et</p>
      <a href="http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/">
          <img width=50 src="images/meetup-logo.png"/>
          Groupe Page
      </a>
    </h3>

    <hr/> <br/>

    <h3>l'AFPy - l'Association Francophone Python</h3>
      Nous ne sommes pas une association, ni membre de l'AFPy mais nous suivons avec interets leurs activites et encourageons nos membres de s'abonner a l'AFPy.
      <a href="http://www.afpy.org/" class="btn btn-primary btn-large">Visitez l'AFPY &raquo;</a>

    <!-- http://hackerspaces.org/wiki/Laboratoire_Ouvert_Grenoblois -->
            </a>
          </div>

          <!-- ========================================================= -->
          <h1>Reunions a venir</h1> <div class="row-fluid">

            <!-- MEETUP --> <a name="Contributions"> </a> <div class="span4"><h2>Contributions</h2>
              Merci de nous faire vos propositions en envoyant un mail a
                <a href="mailto:pyuggre@lists.afpy.org"> pyuggre AT lists.afpy.org </a>.
              Il y a des suggestions sur les sujets, ou comment trouver des sujets a presenter a cette page:
              <a href="Contributions.html">
              <br/>Suggestions sur les presentations</a></li>
	    </div> <!--/span-->
	    </div> <!--/row-->

    {% for event in future_events %}
            <font color=#0000bb> </font> <!-- HACK -->
            <a name="{{ event.aname }}" /> <br/> <div class="span4">
              <h2>{{ event.name }}</h2>
         <br/>Inscrivez-vous sur Meetup <a href="{{ event.meetup_url }}"> <font color=#00bbbb> ici </font> </a>
	    </div> <!--/span-->
      {% endfor %}

          <hr/> <!-- ========================================================= -->
          <h1>Archives des Reunions Pass&eacute;es</h1> <div class="row-fluid">

    {% for event in past_events %}
            <font color=#0000bb> </font> <!-- HACK -->
            <a name="{{ event.aname }}" /> <br/> <div class="span4">
              <h2>{{ event.name }}</h2>
         <br/>Lien sur l'Evenement Meetup <a href="{{ event.meetup_url }}"> <font color=#00bbbb> ici </font> </a>
        <br/>


    {% for talk in event.talks %}
        <b> {{ talk.speaker }}:<br/> "{{ talk.title }}" </b>
        {% if talk.code %} <br/> le code source du demo: <a href="{{ talk.code }}"> <font color=#00bbbb> ici </font> </a> {% endif %}
        {% if talk.slides_url %} <br/> les slides: <a href="{{ talk.slides_url }}"> <font color=#00bbbb> ici </font> </a>
            <div class="slides"> <img src="{{ talk.slides_image }}" > </div>
          </a>
       </b>
        {% endif %}
       <p>
        {{ talk.extra }}
      {% endfor %}
        {{ event.extra }}
            </div><!--/span-->
      {% endfor %}
    

    </div><!--/.fluid-container-->
{% include 'footer.tpl' %}
  </body>
</html>
