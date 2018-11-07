module GoogleSheetsCSVExporter

using HTTP, CSV

struct Sheet
	documentID
	gid
end

function parseURI(uri::HTTP.URI)
	documentID = split(uri.path, "/")[4]
	fragmentParams = uri.fragment |> HTTP.queryparams
	Sheet(documentID, fragmentParams["gid"])
end

function exportURI(sheet::Sheet)
	"https://docs.google.com/spreadsheets/d/$(sheet.documentID)/export?format=csv&gid=$(sheet.gid)"
end

function openURI(uri::String)
	let str
		HTTP.open("GET", uri) do http
			str = read(http, String)
		end
		str
	end
end

function load(url::String)
	HTTP.URI(url) |> parseURI |> exportURI |> openURI |> IOBuffer |> CSV.File
end

end # GoogleSheetsCSVExporter
