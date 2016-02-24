#!/usr/bin/env python

from jinja2 import FileSystemLoader
from jinja2.environment import Environment

"""
    { ## ---- MONTH 201x ------------------------------------------------------------ ##
      "aname": "201x-mon",
      "name":  "Mon 201x",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/XXXXXXXX",
      "talks": [
        {
          "speaker": "Prenom NOM",
          "title":   "talk",
          "slides_url":     "slides_url",
          "slides_image":   "slides_img",
          "code":    "https://github.com/code",
        },
       ],
      }, 

    { ## ---- MONTH 201x ------------------------------------------------------------ ##
      "aname": "201x-mon",
      "name":  "Mon 201x",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/XXXXXXXX",
      "talks": [
        {
          "speaker": "Prenom NOM",
          "title":   "talk",
          "slides_url":     "slides_url",
          "slides_image":   "slides_img",
          "code":    "https://github.com/code",
        },
        {
          "speaker": "Prenom NOM",
          "title":   "talk",
          "slides_url":     "slides_url",
          "slides_image":   "slides_img",
          "code":    "https://github.com/code",
        },
       ],
      }, 
"""


future_events = [
    { ## ---- Mar. 2016 ------------------------------------------------------------ ##
      "aname": "2016-Mar",
      "name":  "29 Mar 2016",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/226447125/",
      "talks": [
        {
          "speaker":     "Speaker",
          "title":       "A definir",
          "slides_url":   "",
          "slides_image": "",
          "code":         "",
        },
       ],
    },

    { ## ---- Apr. 2016 ------------------------------------------------------------ ##
      "aname": "2016-Apr",
      "name":  "26 Apr 2016",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/229090535/",
      "talks": [
        {
          "speaker":     "Speaker",
          "title":       "A definir",
          "slides_url":   "",
          "slides_image": "",
          "code":         "",
        },
       ],
    },

    { ## ---- May. 2016 ------------------------------------------------------------ ##
      "aname": "2016-May",
      "name":  "31 May 2016",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/229090547/",
      "talks": [
        {
          "speaker":     "Speaker",
          "title":       "A definir",
          "slides_url":   "",
          "slides_image": "",
          "code":         "",
        },
       ],
    },

    { ## ---- Jun. 2016 ------------------------------------------------------------ ##
      "aname": "2016-Jun",
      "name":  "21 Jun 2016",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/229090555/",
      "talks": [
        {
          "speaker":     "Speaker",
          "title":       "A definir",
          "slides_url":   "",
          "slides_image": "",
          "code":         "",
        },
       ],
    },

]


past_events = [

    { ## ---- Feb. 2016 ------------------------------------------------------------ ##
      "aname": "2016-Feb",
      "name":  "23 Feb 2016",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/226446981/",
      "talks": [
        {
          "speaker":     "Mike BRIGHT",
          "title":       "Python et MongoDB",
          "slides_url":   "https://github.com/mjbright/jupyter_notebooks/blob/master/2016-Feb-23_Pyugre_UsingMongoDBAndPython/2016-Feb-23_Pyugre_PyMongo.pdf",
          "slides_image": "images/2016-Feb-23_UsingMongoDBAndPython.png",
          "code":         "https://github.com/mjbright/jupyter_notebooks/blob/master/2016-Feb-23_Pyugre_UsingMongoDBAndPython/2016-Feb-23_Pyugre_MongoDB_DEMO.ipynb",
        },
       ],
    },

    { ## ---- Dec. 2015 ------------------------------------------------------------ ##
      "aname": "2015-dec",
      "name":  "10 Dec 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/223559600/",
      "talks": [
        {
          "speaker":     "Matias Guijaro",
          "title":       "Environnements Pythons Virtuels - Pyenv",
          "slides_url":   "http://slides.com/matiasg/pyenv#/",
          "slides_image": "images/2015/2015-Dec-10_Matias_Pyenv.png",
          "code":         "",
        },
        {
          "speaker":     "Arthur Vuillard",
          "title":       "Environnements Pythons Virtuels - PEW",
          "slides_url":   "https://static.hashbang.fr/20151210_pew/#1",
          "slides_image": "images/2015/2015-Dec-10_Arthur_PEW.png",
          "code":         "",
        },
       ],
    },

    { ## ---- Oct. 2015 ------------------------------------------------------------ ##
      "aname": "2015-oct",
      "name":  "Oct 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/223559577/",
      "talks": [
        {
          "speaker": "Ren&eacute; Ribaud",
          "title":   "Redfish & Python Redfish",
          "slides_url":     "https://github.com/uggla/python-redfish/blob/prototype/presentation/Redfish%20%26%20Python%20Redfish.pdf",
          "slides_image":   "images/2015/2015-Oct_Rene_Python-Redfish.png",
          "code":    "https://github.com/uggla/python-redfish",
        },
       ],
      }, 

    { ## ---- Sept. 2015 ------------------------------------------------------------ ##
      "aname": "2015-sep",
      "name":  "Sep 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/219119604/",
      "talks": [
        {
          "speaker": "Mike Bright",
          "title":   "Project Jupyter - L'evolution multi-lang d'IPython",
          "slides_url":     "http://mjbright.github.io/Pygre/2015/2015-Sep-24_Pyugre_HP_DataAnalysisLiftOffForJupyter.slides.html",
          "slides_image":   "images/2015/2015-Sep_ProjectJupyter.png",
          "code":    "https://github.com/mjbright/jupyter_notebooks/tree/master/2015-Sep-24_Pyugre_HP_DataAnalysisLiftOffForJupyter",
        },
       ],
      }, 

    { ## ---- May 2015 ------------------------------------------------------------ ##
      "aname": "2015-may",
      "name":  "Mai 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/220731361/",
      "talks": [
        {
          "speaker": "Damien Accorsi",
          "title":   "Tortilla - un framework for encapsuler les apis Web",
          "code":    "https://github.com/lebouquetin/lebouquetin.github.io/",
          "slides_url":   "http://lebouquetin.github.io/tortilla-presentation-pyuggre-05-2015/",
          "slides_image":   "images/2015/2015-May_Damian_Tortilla.png",
          "dummy":   "dummy",
        },
       ],
      }, 

    { ## ---- Apr 2015 ------------------------------------------------------------ ##
      "aname": "2015-avr",
      "name":  "Avr 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/220731341/",
      "talks": [
        {
          "speaker": "Gilles Vandelle",
          "title":   "Twisted - event-driven networking engine' ecrit en Python",
          "code":    "https://github.com/gvtech/python_twisted_examples",
        },
       ],
      }, 

        { ## ---- Fev. 2015 ------------------------------------------------------------ ##
      "aname": "2015-fev",
      "name":  "Fev 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/219119587",
      "talks": [
        {
          "speaker": "Arthur Vuillard",
          "title":   "Sentry - un framework (multi-langage) pour error logging",
          "slides_url":     "http://static.hashbang.fr/20150226_sentry/",
          "slides_image":   "images/2015/2015-Feb_Arthur_Sentry.png",
        },
       ],
      }, 

        { ## ---- Jan. 2015 ------------------------------------------------------------ ##
      "aname": "2015-jan",
      "name":  "Jan 2015",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/219119567/",
      "talks": [
        {
          "speaker": "Damien Accorsi",
          "title":   "Scrapy - Web crawling engine",
          "slides_url":     "http://lebouquetin.github.io/scrapy-presentation-pyuggre-01-2015",
          "slides_image":   "images/2015/2015-Jan_Scrapy.png",
          "code":    "https://github.com/lebouquetin/lebouquetin.github.io/tree/master/scrapy-presentation-pyuggre-01-2015",
        },
       ],
      }, 

        { ## ---- Nov. 2014 ------------------------------------------------------------ ##
      "aname": "2014-nov",
      "name":  "Nov 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/202492252/",
      "talks": [
        {
          "speaker": "Arthur Vuillard",
          "title":   "Django",
          "slides_url":   "https://static.hashbang.fr/20141127_grenoble_django/presentation.html",
          "slides_image":   "images/2014/2014-Nov_Arthur_Django.png",
          "dummy":   "dummy",
        },
       ],
      }, 

    { ## ---- Oct 2014 ------------------------------------------------------------ ##
      "aname": "2014-oct",
      "name":  "Oct 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/202492182/",
      "talks": [
        {
          "speaker": "Frederic Mantegazza",
          "title":   "&micro;Python pour &micro;controllers",
        },
        {
          "speaker": "Matias Guijarro",
          "title":   "asyncio",
        },
       ],
      }, 

    { ## ---- Sept. 2014 ------------------------------------------------------------ ##
      "aname": "2014-sep",
      "name":  "Sep 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/202491842/",
      "talks": [
        {
          "speaker": "Jerome Kieffer",
          "title":   "l'Ecosysteme Scientifique de Python (numpy, scipy, matplotlib, cython)",
          "code":    "https://github.com/kif/python_tutorials",
        },
       ],
      }, 

    { ## ---- May 2014 ------------------------------------------------------------ ##
      "aname": "2014-mai",
      "name":  "Mai 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/175530042/",
      "talks": [
        {
          "speaker": "Sylvain Bauza",
          "title":   "Retour sur l'OpenStack Summit a Atlanta (May 2014)",
        },
        {
          "speaker": "Arthur Vuillard",
          "title":   "Retour sur Django Con EU 2014",
          "slides_url":     "https://static.hashbang.fr/20140522_grenoble_djangoconeu/presentation.html#1",
          "slides_image":   "2014/2014-May-22/images/Arthur_DjangoConEU.PNG",
        },
        {
          "speaker": "Tout le monde",
          "title":   "Discussion sur les IDEs",
        },
       ],
      }, 
    
    { ## ---- April 2014 ------------------------------------------------------------ ##
      "aname": "2014-avr",
      "name":  "Avr 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/174121922",
      "talks": [
        {
          "speaker": "Matias Guijarro",
          "title":   "Introduction to gevent",
          "slides_url":     "http://www.labwiz.org/gevent_pyugg/presentation.html#slide1",
          "image":   "2014/2014-Apr-17-Gevent/images/Matias_Gevent.PNG",
          "code":    "https://github.com/mguijarr/demo_pyugg",
        },
       ],
      }, 

    { ## ---- March 2014 ------------------------------------------------------------ ##
      "aname": "2014-mar",
      "name":  "Mar 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/171032122",
      "talks": [
        {
          "speaker": "Mike Bright",
          "title":   "Lightweight Virtualization with Docker",
          "slides_url":     "http://mjbright.github.io/Pygre/2014/2014-Mar-27-LightWeightVirtualizationWithDocker/presentation.html",
          "slides_image":   "2014/2014-Mar-27-LightWeightVirtualizationWithDocker/images/SLIDE1.PNG",
        },
       ],
        }, 
    { ## ---- Feb   2014 ------------------------------------------------------------ ##
      "aname": "2014-fev",
      "name":  "Fev 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/162831232/",
      "talks": [
        {
          "speaker": "Sylvain Bauza",
          "title":   "Python et Openstack : presentation de certaines librairies et frameworks",
          "slides_url":     "http://sbauza.github.io/2014/02/27/pyuggre_openstack.html",
          "slides_image":   "2014/images/2014-Feb-27_SylvainBauza_Presa.png",
          "extra": '''
               <p>
       La solution de IaaS Openstack est 100% Python.
       <br/> De nombreux outils et librairies sont utilises qui ne lui sont pas specifiques.
       <br/> C'est l'occasion d'changer autour de ces frameworks.

       <ul>
       <li>Stevedore (extensions)</li>
       <li>Flask</li>
       <li>Pecan/WSME</li>
       <li>Cliff (CLI)</li>
       <li>Alembic (migration SQLalchemy)</li>
       <li>Testtools/Testr (TestsU)</li>
       <li>Oslo</li>
       </ul>
        '''
        },
       ],
     },
    
    { ## ---- Jan 2014 ------------------------------------------------------------ ##
      "aname": "2014-jan",
      "name":  "Jan 2014",
      "meetup_url": "http://www.meetup.com/Groupe-dutilisateurs-Python-Grenoble/events/158240072/",
      "talks": [
        {
          "speaker": '<a href="http://www.linkedin.com/profile/view?id=5259119">  Mike Bright </a>',
          "title":   "Intro / Tendences Dev en 2014",
          "slides_url":     "../reveal.js/PRESENTATIONS/2014-01-23_PyGre1/intro.html",
          "slides_image":   "2014/images/2014-Jan_Mike_Tendences.png",
        },
        {
          "speaker": "Arthur Vuillard",
          "title":   "Tester en Python",
          "slides_url":     "http://static.hashbang.fr/python_grenoble_testing/presentation.html",
          "slides_image":   "2014/images/2014-Jan_Arthur_TesterEnPython.png",
        },
       ],
        "extra": """
      <br/>
      le 23 Janvier a eu lieu la premiere reunion du groupe, a la Casemate
      <br/>
      Bien acceuilli par le LOG (<a href="http://hackerspaces.org/wiki/Grenoble">Grenoble Hackerspace </a>) nous etions 17
      a discuter, grignoter, manger et boire jusqu'a 23h.
      <br/>

      <p>
      <img width=512 src="./2014/images/2014-01-23 19.25.02.jpg" />

      <p>
        </div><!--/span-->
      </div><!--/row-->

      <hr>

"""
      }, 
]
 

env = Environment()
env.loader = FileSystemLoader('.')
tmpl = env.get_template('index.tpl')

f = open('op.html', 'w')
f.write(tmpl.render( future_events = future_events, past_events = past_events ))

