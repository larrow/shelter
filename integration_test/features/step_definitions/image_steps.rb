那么(/^可以在(.*)中添加镜像$/) do |label|

  image = "#{namespaces[label]}/test1"
  expect{Registry.push image, :v1}.not_to raise_error
end

那么(/^可以删除(.*)中的镜像$/) do |label|
  _image = "#{namespaces[label]}/test1"
  pending
end
