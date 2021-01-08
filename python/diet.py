#!/usr/bin/python3
#coding: utf-8

import argparse

def produit_en_croit(kcal_cent_gramme, poids):
    '''Retourne le produit en croix'''
    return round((poids * kcal_cent_gramme)/100)

def compute_cal_100g(kcal_total, poids_total):
    '''Retourne le nombre de kcal pour 100g'''
    return round((100*kcal_total)/poids_total)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    subparsers = parser.add_subparsers(dest='subcommand')

    parser_kcal = subparsers.add_parser('kcal')
    parser_kcal.add_argument("-k", help="Nombre de calories pour 100g", dest="k", required=True)
    parser_kcal.add_argument("-p", help="Quantitée mesurée", dest="p", required=True)

    parser_compute = subparsers.add_parser('compute')
    parser_compute.add_argument("-pt", help="Poids total", dest="pt", required=True)
    parser_compute.add_argument("-kt", help="Calories total", dest="kt", required=True)

    args = parser.parse_args()

    try:
        if args.subcommand == "kcal":
            print(str(produit_en_croit(float(args.k), float(args.p))))
        elif args.subcommand == "compute":
            print(str(compute_cal_100g(float(args.kt), float(args.pt))) + " kcal/100g")
        else:
            parser.print_help()
    except: 
        parser.print_help()