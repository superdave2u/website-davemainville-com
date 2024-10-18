for f in ../../../public/project/*.webp; do
  # Extract the base name of the file (without directory path)
  base_name=$(basename "$f" .webp)
  
  # Define the new markdown file name
  new_file="${base_name}.md"
  
  # Check if the markdown file already exists, if so, skip it
  if [ -f "$new_file" ]; then
    echo "Skipping $new_file, already exists."
    continue
  fi

  # Copy the template to the new file
  cp _template.md "$new_file"

  # Replace the heroImage line with the correct image path
  sed -i "s|heroImage:.*|heroImage: '$f'|" "$new_file"

  # Convert the filename to a camel-case title
  camel_case_title=$(echo "$base_name" | sed -r 's/(^|_)([a-z])/\U\2/g')
  
  # Replace the title line with the camel-cased title
  sed -i "s|title:.*|title: '$camel_case_title'|" "$new_file"
  
  echo "Created $new_file"
done
