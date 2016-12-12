#!/bin/sh

# cleanup the runtimes file
echo "Runtime of RevBayes tutorials in seconds:" > runtime.txt
echo "Number of wrong results:" > Test_results.txt



# Let us go through all tutorial directories
for d in */ ; do
    
    # check if there is a scripts directory
    if [ -d "$d/scripts" ]; then
    
        # we need to go into the directory
        cd $d
        
        # print the name of the directory into our output
        echo "$d" >> ../Test_results.txt
        echo "$d" >> ../runtime.txt
        
        # now go through all the tutorial scripts
        for s in scripts/*.Rev ; do
            
            # get the current time for checking the runtime
            date1=$(date +"%s")
            
            # now run RevBayes
            rb ../seed.Rev $s
            
            # check how long the run took
            date2=$(date +"%s")
            diff=$(($date2-$date1))
            echo "$s -- $diff" >> ../runtime.txt
            
            echo "    $s" >> ../Test_results.txt
            # now also check the difference in the results
#            for f in output/*.Rev ; do
#                diff -I '#.*' ../expected_output/$d/$f output/$f | wc -l >> ../Test_results.txt
#            done
            
            # cleaning up
#            rm -rf output
        done
        
        cd ..

        echo "$d"
        
    fi
done
