if node['prometheus_exporters']['redis']['install']
  redis_exporter 'main' do
    action %i(install enable start)
  end
end
