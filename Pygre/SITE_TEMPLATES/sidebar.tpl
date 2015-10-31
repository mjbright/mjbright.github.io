        <div class="span3">
          <div class="well sidebar-nav">
            <a href="/Pygre/"> <img src="images/python.png"> </a>
            <ul class="nav nav-list">
              <li class="nav-header">Abonnez-vous a la Newsletter Python</li>
              <li><a href="http://lists.afpy.org/listinfo/pyuggre">Abonnez-vous</a></li>

              <li class="nav-header">Apprentissage Python</li>
              <li><a href="LearningPython.html">Apprentissage</a></li>

              <li class="nav-header">Meetups a venir</li>
              <li><a href="#Contributions">Contributions</a></li>
              {% for event in future_events %}
                 <li><a href="#{{ event.aname }}">{{ event.name }}</a></li>
              {% endfor %}

              <li class="nav-header">Archives</li>
              {% for event in past_events %}
                 <li><a href="#{{ event.aname }}">{{ event.name }}</a></li>
              {% endfor %}

  <li class="nav-header">Evenements</li>
              <!-- ************ OLD EVENTS:
              <li><a href="http://www.pycon.fr/">Pyconfr 2014 [25-28 Octobre @Lyon]</a></li>
              <li><a href="http://www.meetup.com/OpenStack-Rhone-Alpes/events/187083102/?a=ea1_grp&rv=ea1&_af_eid=187083102&_af=event"> OpenStack Rhone-Alpes Meetup "Vers Juno" [18h30, 1 Juillet @HP]</a></li>
              <li><a href="https://ep2014.europython.eu/en/">EuroPython 2014, [21-27 juillet @Berlin]</a></li>
              ******** -->

              <li class="nav-header">Partenaires</li>
	    <img src="http://cdn.oreillystatic.com/community/promote/ug_ad_125_frog2.gif">
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
