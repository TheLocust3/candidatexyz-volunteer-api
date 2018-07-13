import sys
import json
from PyPDF2 import PdfFileWriter, PdfFileReader

def update_form_values(infile, outfile, newvals):
    pdf = PdfFileReader(open(infile, 'rb'))
    writer = PdfFileWriter()

    for i in range(pdf.getNumPages()):
        page = pdf.getPage(i)
        try:
            writer.updatePageFormFieldValues(page, newvals)
            writer.addPage(page)
        except Exception as e:
            print(repr(e))
            writer.addPage(page)

    with open(outfile, 'wb') as out:
        writer.write(out)


# python fill_pdf.py INPUT_FILE_NAME OUTPUT_FILE_NAME JSON_FORM_DATA_FILE_NAME
if __name__ == '__main__':
    pdf = sys.argv[1]
    out = sys.argv[2]

    with open(sys.argv[3]) as json_data:
        d = json.load(json_data)

        update_form_values(pdf, out, d)

