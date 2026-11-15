// main template for {{ cookiecutter.slug}}
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.{{ cookiecutter.parameter_key }};
local instance = inv.parameters._instance;
// The namespace parameters are optional, so that components which don't declare
// them (e.g. because a customized class/defaults.yml was kept during a cruft
// update) still compile.
local createNamespace = std.get(params, 'createNamespace', false);
local namespaceLabels = std.get(params, 'namespaceLabels', {});
local namespaceAnnotations = std.get(params, 'namespaceAnnotations', {});

// Define outputs below
{
  [if createNamespace then '00_namespace']: kube.Namespace(params.namespace) + {
    metadata+: {
      labels+:
        {
          component: '{{ cookiecutter.slug }}',
          instance: instance,
        }
        + namespaceLabels,
      annotations+:
        {
          'syn.tools/source': '{{ cookiecutter.github_url }}',
        }
        + namespaceAnnotations,
    },
  },
}
