class FilesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    params.permit(:file_location)
    @active_dir = validate_file(params[:file_location]) + '/*'
  end

  def show
    params.permit(:file_location)
    @active_dir = validate_file(params[:file_location]) + '/*'

    respond_to do |format|
      format.js { }
    end
  end

=begin
  def return
    params.permit(:file_location)
    pn = Pathname.new(validate_file(params[:file_location]))
    dir, base = pn.split
    @active_dir = dir.to_s + '/*'

    respond_to do |format|
      format.js { render "show" }
    end
  end
=end

  def create
    params.permit(:file_location, :file_new)
    file_location = validate_file(params[:file_location])
    file_new = validate_name(params[:file_new])

    directory = File.join(file_location, file_new)

    if File.directory?(directory)
    else
      FileUtils.mkdir_p(directory)

      @active_dir = file_location + '/*'

      respond_to do |format|
        format.js { render "show" }
      end
    end
  end

  def update
    params.permit(:file_location, :file_orig, :file_new)
    file_location = validate_file(params[:file_location])
    file_orig = validate_name(params[:file_orig])
    file_new = validate_name(params[:file_new])

    Dir.glob(file_location + '/*').sort.each do |f|
      if File.basename(f) == file_orig
        File.rename(f, File.join(file_location, file_new))

        @active_dir = file_location + '/*'

        respond_to do |format|
          format.js { render "show" }
        end
      end
    end
  end

  def destroy
    params.permit(:file_location, :file_name)
    file_location = validate_file(File.join(params[:file_location], params[:file_name])) # Get the entire path.

    if File.directory?(file_location) # Check if it is a directory or a file.
      FileUtils.rm_rf(file_location, :secure => true) # Delete the directory.

      file_location = validate_file(File.join(params[:file_location])) # Get the rest of the path to feed @active_dir.

      @active_dir = file_location + '/*'
    else
      file_location = validate_file(File.join(params[:file_location])) # Else if it is a file, get the path without the file.
      file_name = params[:file_name]
      File.delete(File.join(file_location, file_name)) # Delet the file.

      @active_dir = file_location + '/*'
    end

    respond_to do |format|
      format.js { render "show" }
    end
  end

  def view_pdf
    params.permit(:file_location)
    pdf = validate_file(params[:file_location])
    send_file pdf, :type => "application/pdf", :disposition => 'inline'
  end

  def download
    params.permit(:file_location)
    file = validate_file(params[:file_location])
    send_file file, :x_sendfile => true
  end

  def upload
    params.permit(:file_location)
    @uploaded_files = params.require(:file).permit! # Take the files which are sent by HTTP POST request.
    @active_dir = validate_file(params[:file_location])
    time_footprint = Time.now.to_i.to_s # Generate a unique number to rename the files to prevent duplication.

    @uploaded_files.each do |key, file|
      File.open(Rails.root.join(@active_dir, file.original_filename), 'wb') do |f|
        f.write(file.read)
        File.rename(f, @active_dir + '/' + time_footprint + '_' + file.original_filename)
      end
    end

    render json: { message: 'You have successfully uploaded your images.' } # Return a JSON object amd success message if uploading is successful
  end

  private

  @@public_root = File.join('public','files')


  def validate_name(file_name)
    file_name = file_name.gsub(/[\/\\:\*\?\"<>\|]/, '_')
    return file_name
  end

  def validate_file(file_location)

    if file_location.blank?
      return @@public_root
    else
      if (file_location =~ /\/..\//) != nil # Check against cases with /../ in the string.
        return @@public_root
      else
        return File.join('public', file_location)
      end
    end
  end
end
