from django.views.generic.simple import direct_to_template
def view(request):
    context = {}
    return direct_to_template(request, template='template.html',
                              extra_context=context)
