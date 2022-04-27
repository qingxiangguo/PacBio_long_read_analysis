ofh.write(delta_header)
ofh.write("\n")
for readname,drecord_list in deltaHash.iteritems():
    alignment_range = readRange[readname]
    for record in drecord_list:
       #get alignments that pass basic filtering
        pfalignments = []
        for alnmt in record.alignments:
            if alignment_is_good(record, alnmt, alignment_range):
                pfalignments.append(alnmt)
            else:
                efh.write("Remove Alignment:\n")
                efh.write(deltaRecordHeaderToString(record) + "\n")
                efh.write(deltaAlignmentHeaderToString(alnmt)+ "\n")

        #0 or 1 alignments, good to go! Otherwise idk
        #just log them and output them anyway
        if len(pfalignments) > 1:
            efh.write("Multiple Alignments\n")
            efh.write(deltaRecordHeaderToString(record) + "\n")
            for a in pfalignments:
                efh.write(deltaAlignmentHeaderToString(a)+ "\n")

        #substitute old alignments with filtered ones
        record.alignments[:] = []
        for al in pfalignments:
            record.alignments.append(al)

        #delta spec only outputs record if there are alignments
        if(len(record.alignments) > 0):
            ofh.write( deltaRecordToOriginalFormat(record))
            ofh.write("\n")

efh.close()
ofh.close()
