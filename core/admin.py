from django.contrib import admin
from .models import Project, Contact, PersonalInfo 

admin.site.register(Project)
admin.site.register(Contact)
admin.site.register(PersonalInfo)