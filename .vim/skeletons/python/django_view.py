from django import http
from django.contrib.auth.decorators import login_required
from django.core.urlresolvers import reverse
from django.shortcuts import get_object_or_404
from django.shortcuts import render

def view(request):
    return render(request, 'template.html', {
    })
