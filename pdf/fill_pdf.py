import sys
import json
from PyPDF2 import PdfFileWriter, PdfFileReader
from PyPDF2.generic import NameObject

def update_form_values(infile, outfile, newvals):
    pdf = PdfFileReader(open(infile, 'rb'))
    writer = PdfFileWriter()

    for i in range(pdf.getNumPages()):
        page = pdf.getPage(i)
        try:
            writer.updatePageFormFieldValues(page, newvals['textfield'])
            update_checkbox_values(page, newvals['checkbox'])
            writer.addPage(page)
        except Exception as e:
            print(repr(e))
            writer.addPage(page)

    with open(outfile, 'wb') as out:
        writer.write(out)

def update_checkbox_values(page, fields):

    for j in range(0, len(page['/Annots'])):
        writer_annot = page['/Annots'][j].getObject()
        for field in fields:
            if writer_annot.get('/T') == field:
                writer_annot.update({
                    NameObject('/V'): NameObject(fields[field]),
                    NameObject('/AS'): NameObject(fields[field])
                })

# python fill_pdf.py INPUT_FILE_NAME OUTPUT_FILE_NAME JSON_FORM_DATA_FILE_NAME
if __name__ == '__main__':
    pdf = sys.argv[1]
    out = sys.argv[2]

    with open(sys.argv[3]) as json_data:
        d = json.load(json_data)

        update_form_values(pdf, out, d)

