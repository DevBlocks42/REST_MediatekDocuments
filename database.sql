-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : fdb1028.awardspace.net
-- Généré le : lun. 03 mars 2025 à 19:04
-- Version du serveur : 8.0.32
-- Version de PHP : 8.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `4597732_mediatek`
--
CREATE DATABASE IF NOT EXISTS `4597732_mediatek` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `4597732_mediatek`;

-- --------------------------------------------------------

--
-- Structure de la table `abonnement`
--

CREATE TABLE `abonnement` (
  `id` varchar(5) NOT NULL,
  `dateFinAbonnement` date DEFAULT NULL,
  `idRevue` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `abonnement`
--

INSERT INTO `abonnement` (`id`, `dateFinAbonnement`, `idRevue`) VALUES
('00018', '2025-03-02', '10001'),
('00019', '2025-02-21', '10001'),
('00020', '2025-03-20', '10001'),
('00021', '2025-03-04', '10001'),
('00022', '2025-03-09', '10002');

--
-- Déclencheurs `abonnement`
--
DELIMITER $$
CREATE TRIGGER `suppression_commande_abonnement` AFTER DELETE ON `abonnement` FOR EACH ROW BEGIN
	DELETE FROM commande WHERE commande.id = OLD.id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

CREATE TABLE `commande` (
  `id` varchar(5) NOT NULL,
  `dateCommande` date DEFAULT NULL,
  `montant` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`id`, `dateCommande`, `montant`) VALUES
('00018', '2025-02-20', 5.99),
('00019', '2025-02-20', 8.99),
('00020', '2025-02-20', 6.98),
('00021', '2025-02-21', 6.99),
('00022', '2025-02-21', 8.99),
('00024', '2025-02-25', 9.95),
('00025', '2025-02-25', 12.89),
('00026', '2025-02-28', 6.99),
('00027', '2025-02-28', 4.99),
('00028', '2025-02-28', 8),
('00029', '2025-03-01', 3.99),
('00030', '2025-03-02', 4.48);

--
-- Déclencheurs `commande`
--
DELIMITER $$
CREATE TRIGGER `generer_id_commande` BEFORE INSERT ON `commande` FOR EACH ROW BEGIN
DECLARE nextID INT;

SELECT COALESCE(MAX(CAST(id AS UNSIGNED)), 0) + 1 INTO nextID FROM commande;

SET NEW.id = LPAD(nextID, 5, '0');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commandedocument`
--

CREATE TABLE `commandedocument` (
  `id` varchar(5) NOT NULL,
  `idLivreDvd` varchar(5) NOT NULL,
  `idSuivi` int NOT NULL,
  `nbExemplaire` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `commandedocument`
--

INSERT INTO `commandedocument` (`id`, `idLivreDvd`, `idSuivi`, `nbExemplaire`) VALUES
('00024', '00007', 2, 4),
('00025', '20001', 1, 2),
('00026', '00017', 3, 2),
('00027', '00017', 3, 10),
('00028', '00017', 1, 2),
('00029', '00007', 1, 2),
('00030', '00007', 1, 4);

--
-- Déclencheurs `commandedocument`
--
DELIMITER $$
CREATE TRIGGER `generer_exemplaires` AFTER UPDATE ON `commandedocument` FOR EACH ROW BEGIN
	DECLARE numeroExemplaire INT;
    DECLARE dateAchatCommande DATE;
    DECLARE compteur INT DEFAULT 0;
	IF (NEW.idSuivi = 3) THEN
    	SELECT dateCommande INTO dateAchatCommande FROM commande WHERE id=OLD.id;
    	SELECT max(numero) + 1 INTO numeroExemplaire FROM exemplaire WHERE id=OLD.idLivreDvd;
    	IF (numeroExemplaire IS NULL) THEN 
        	SET numeroExemplaire = 1;
        END IF;
        WHILE (compteur < OLD.nbExemplaire) DO
    		INSERT INTO exemplaire VALUES (OLD.idLivreDvd, numeroExemplaire, dateAchatCommande, "", "00001");
            SET compteur = compteur + 1;
            SET numeroExemplaire = numeroExemplaire + 1;
        END WHILE;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `suppression_commande` AFTER DELETE ON `commandedocument` FOR EACH ROW BEGIN
	DELETE FROM commande WHERE commande.id = OLD.id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `document`
--

CREATE TABLE `document` (
  `id` varchar(10) NOT NULL,
  `titre` varchar(60) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `idRayon` varchar(5) NOT NULL,
  `idPublic` varchar(5) NOT NULL,
  `idGenre` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `document`
--

INSERT INTO `document` (`id`, `titre`, `image`, `idRayon`, `idPublic`, `idGenre`) VALUES
('00001', 'Quand sort la recluse', '', 'LV003', '00002', '10014'),
('00002', 'Un pays à l\'aube', '', 'LV001', '00002', '10004'),
('00003', 'Et je danse aussi', '', 'LV002', '00003', '10013'),
('00004', 'L\'armée furieuse', '', 'LV003', '00002', '10014'),
('00005', 'Les anonymes', '', 'LV001', '00002', '10014'),
('00006', 'La marque jaune', '', 'BD001', '00003', '10001'),
('00007', 'Dans les coulisses du musée', '', 'LV001', '00003', '10006'),
('00008', 'Histoire du juif errant', '', 'LV002', '00002', '10006'),
('00009', 'Pars vite et reviens tard', '', 'LV003', '00002', '10014'),
('00010', 'Le vestibule des causes perdues', '', 'LV001', '00002', '10006'),
('00011', 'L\'île des oubliés', '', 'LV002', '00003', '10006'),
('00012', 'La souris bleue', '', 'LV002', '00003', '10006'),
('00013', 'Sacré Pêre Noël', '', 'JN001', '00001', '10001'),
('00014', 'Mauvaise étoile', '', 'LV003', '00003', '10014'),
('00015', 'La confrérie des téméraires', '', 'JN002', '00004', '10014'),
('00016', 'Le butin du requin', '', 'JN002', '00004', '10014'),
('00017', 'Catastrophes au Brésil', '', 'JN002', '00004', '10014'),
('00018', 'Le Routard - Maroc', '', 'DV005', '00003', '10011'),
('00019', 'Guide Vert - Iles Canaries', '', 'DV005', '00003', '10011'),
('00020', 'Guide Vert - Irlande', '', 'DV005', '00003', '10011'),
('00021', 'Les déferlantes', '', 'LV002', '00002', '10006'),
('00022', 'Une part de Ciel', '', 'LV002', '00002', '10006'),
('00023', 'Le secret du janissaire', '', 'BD001', '00002', '10001'),
('00024', 'Pavillon noir', '', 'BD001', '00002', '10001'),
('00025', 'L\'archipel du danger', '', 'BD001', '00002', '10001'),
('00026', 'La planète des singes', '', 'LV002', '00003', '10002'),
('10001', 'Arts Magazine', '', 'PR002', '00002', '10016'),
('10002', 'Alternatives Economiques', '', 'PR002', '00002', '10015'),
('10003', 'Challenges', '', 'PR002', '00002', '10015'),
('10004', 'Rock and Folk', '', 'PR002', '00002', '10016'),
('10005', 'Les Echos', '', 'PR001', '00002', '10015'),
('10006', 'Le Monde', '', 'PR001', '00002', '10018'),
('10007', 'Telerama', '', 'PR002', '00002', '10016'),
('10008', 'L\'Obs', '', 'PR002', '00002', '10018'),
('10009', 'L\'Equipe', '', 'PR001', '00002', '10017'),
('10010', 'L\'Equipe Magazine', '', 'PR002', '00002', '10017'),
('10011', 'Geo', '', 'PR002', '00003', '10016'),
('20001', 'Star Wars 5 L\'empire contre attaque', '', 'DF001', '00003', '10002'),
('20002', 'Le seigneur des anneaux : la communauté de l\'anneau', '', 'DF001', '00003', '10019'),
('20003', 'Jurassic Park', '', 'DF001', '00003', '10002'),
('20004', 'Matrix', '', 'DF001', '00003', '10002');

-- --------------------------------------------------------

--
-- Structure de la table `dvd`
--

CREATE TABLE `dvd` (
  `id` varchar(10) NOT NULL,
  `synopsis` text,
  `realisateur` varchar(20) DEFAULT NULL,
  `duree` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `dvd`
--

INSERT INTO `dvd` (`id`, `synopsis`, `realisateur`, `duree`) VALUES
('20001', 'Luc est entraîné par Yoda pendant que Han et Leia tentent de se cacher dans la cité des nuages.', 'George Lucas', 124),
('20002', 'L\'anneau unique, forgé par Sauron, est porté par Fraudon qui l\'amène à Foncombe. De là, des représentants de peuples différents vont s\'unir pour aider Fraudon à amener l\'anneau à la montagne du Destin.', 'Peter Jackson', 228),
('20003', 'Un milliardaire et des généticiens créent des dinosaures à partir de clonage.', 'Steven Spielberg', 128),
('20004', 'Un informaticien réalise que le monde dans lequel il vit est une simulation gérée par des machines.', 'Les Wachowski', 136);

-- --------------------------------------------------------

--
-- Structure de la table `etat`
--

CREATE TABLE `etat` (
  `id` char(5) NOT NULL,
  `libelle` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `etat`
--

INSERT INTO `etat` (`id`, `libelle`) VALUES
('00001', 'neuf'),
('00002', 'usagé'),
('00003', 'détérioré'),
('00004', 'inutilisable');

-- --------------------------------------------------------

--
-- Structure de la table `exemplaire`
--

CREATE TABLE `exemplaire` (
  `id` varchar(10) NOT NULL,
  `numero` int NOT NULL,
  `dateAchat` date DEFAULT NULL,
  `photo` varchar(500) NOT NULL,
  `idEtat` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `exemplaire`
--

INSERT INTO `exemplaire` (`id`, `numero`, `dateAchat`, `photo`, `idEtat`) VALUES
('00007', 1, '2025-02-13', '', '00001'),
('00007', 2, '2025-02-13', '', '00001'),
('00007', 3, '2025-02-12', '', '00001'),
('00007', 4, '2025-02-12', '', '00001'),
('00007', 5, '2025-02-12', '', '00001'),
('00007', 6, '2025-02-12', '', '00001'),
('00007', 7, '2025-02-12', '', '00001'),
('00007', 8, '2025-02-25', '', '00001'),
('00007', 9, '2025-02-25', '', '00001'),
('00007', 10, '2025-02-25', '', '00001'),
('00007', 11, '2025-02-25', '', '00001'),
('00007', 12, '2025-02-25', '', '00001'),
('00007', 13, '2025-02-25', '', '00001'),
('00017', 1, '2025-02-17', '', '00001'),
('00017', 2, '2025-02-17', '', '00001'),
('00017', 3, '2025-02-17', '', '00001'),
('00017', 4, '2025-02-17', '', '00001'),
('00017', 5, '2025-02-17', '', '00001'),
('00017', 6, '2025-02-17', '', '00001'),
('00017', 7, '2025-02-17', '', '00001'),
('00017', 8, '2025-02-17', '', '00001'),
('00017', 9, '2025-02-17', '', '00001'),
('00017', 10, '2025-02-17', '', '00001'),
('00017', 11, '2025-02-28', '', '00001'),
('00017', 12, '2025-02-28', '', '00001'),
('00017', 13, '2025-02-28', '', '00001'),
('00017', 14, '2025-02-28', '', '00001'),
('00017', 15, '2025-02-28', '', '00001'),
('00017', 16, '2025-02-28', '', '00001'),
('00017', 17, '2025-02-28', '', '00001'),
('00017', 18, '2025-02-28', '', '00001'),
('00017', 19, '2025-02-28', '', '00001'),
('00017', 20, '2025-02-28', '', '00001'),
('00017', 21, '2025-02-28', '', '00001'),
('00017', 22, '2025-02-28', '', '00001'),
('10001', 1, '2025-02-20', '', '00001'),
('10001', 2, '2025-02-21', '', '00001'),
('10002', 418, '2021-12-01', '', '00001'),
('10002', 419, '2024-10-10', '', '00001'),
('10007', 3237, '2021-11-23', '', '00001'),
('10007', 3238, '2021-11-30', '', '00001'),
('10007', 3239, '2021-12-07', '', '00001'),
('10007', 3240, '2021-12-21', '', '00001'),
('10011', 505, '2022-10-16', '', '00001'),
('10011', 506, '2021-04-01', '', '00001'),
('10011', 507, '2021-05-03', '', '00001'),
('10011', 508, '2021-06-05', '', '00001'),
('10011', 509, '2021-07-01', '', '00001'),
('10011', 510, '2021-08-04', '', '00001'),
('10011', 511, '2021-09-01', '', '00001'),
('10011', 512, '2021-10-06', '', '00001'),
('10011', 513, '2021-11-01', '', '00001'),
('10011', 514, '2021-12-01', '', '00001'),
('20001', 1, '2025-02-25', '', '00001'),
('20001', 2, '2025-02-25', '', '00001'),
('20002', 1, '2025-02-17', '', '00001'),
('20002', 2, '2025-02-17', '', '00001'),
('20002', 3, '2025-02-17', '', '00001'),
('20002', 4, '2025-02-17', '', '00001'),
('20002', 5, '2025-02-17', '', '00001'),
('20002', 6, '2025-02-17', '', '00001'),
('20002', 7, '2025-02-17', '', '00001'),
('20002', 8, '2025-02-17', '', '00001'),
('20002', 9, '2025-02-17', '', '00001'),
('20002', 10, '2025-02-17', '', '00001'),
('20002', 11, '2025-02-17', '', '00001'),
('20002', 12, '2025-02-17', '', '00001'),
('20002', 13, '2025-02-17', '', '00001'),
('20002', 14, '2025-02-17', '', '00001'),
('20002', 15, '2025-02-17', '', '00001'),
('20002', 16, '2025-02-17', '', '00001'),
('20002', 17, '2025-02-17', '', '00001'),
('20002', 18, '2025-02-17', '', '00001'),
('20002', 19, '2025-02-17', '', '00001'),
('20002', 20, '2025-02-17', '', '00001'),
('20002', 21, '2025-02-17', '', '00001'),
('20002', 22, '2025-02-17', '', '00001'),
('20002', 23, '2025-02-17', '', '00001'),
('20002', 24, '2025-02-17', '', '00001'),
('20002', 25, '2025-02-17', '', '00001'),
('20002', 26, '2025-02-17', '', '00001'),
('20002', 27, '2025-02-17', '', '00001'),
('20002', 28, '2025-02-17', '', '00001'),
('20002', 29, '2025-02-17', '', '00001'),
('20002', 30, '2025-02-17', '', '00001'),
('20002', 31, '2025-02-17', '', '00001'),
('20002', 32, '2025-02-17', '', '00001'),
('20002', 33, '2025-02-17', '', '00001'),
('20002', 34, '2025-02-17', '', '00001'),
('20002', 35, '2025-02-17', '', '00001'),
('20002', 36, '2025-02-17', '', '00001'),
('20002', 37, '2025-02-17', '', '00001'),
('20002', 38, '2025-02-17', '', '00001'),
('20002', 39, '2025-02-17', '', '00001'),
('20002', 40, '2025-02-17', '', '00001'),
('20002', 41, '2025-02-17', '', '00001'),
('20002', 42, '2025-02-17', '', '00001'),
('20002', 43, '2025-02-17', '', '00001'),
('20002', 44, '2025-02-17', '', '00001'),
('20002', 45, '2025-02-17', '', '00001'),
('20002', 46, '2025-02-17', '', '00001'),
('20002', 47, '2025-02-17', '', '00001'),
('20002', 48, '2025-02-17', '', '00001'),
('20002', 49, '2025-02-17', '', '00001'),
('20002', 50, '2025-02-17', '', '00001'),
('20002', 51, '2025-02-17', '', '00001'),
('20002', 52, '2025-02-17', '', '00001'),
('20002', 53, '2025-02-17', '', '00001'),
('20002', 54, '2025-02-17', '', '00001'),
('20002', 55, '2025-02-17', '', '00001'),
('20002', 56, '2025-02-17', '', '00001'),
('20002', 57, '2025-02-17', '', '00001'),
('20002', 58, '2025-02-17', '', '00001'),
('20002', 59, '2025-02-17', '', '00001'),
('20002', 60, '2025-02-17', '', '00001'),
('20002', 61, '2025-02-17', '', '00001'),
('20002', 62, '2025-02-17', '', '00001'),
('20002', 63, '2025-02-17', '', '00001'),
('20002', 64, '2025-02-17', '', '00001'),
('20002', 65, '2025-02-17', '', '00001'),
('20002', 66, '2025-02-17', '', '00001'),
('20002', 67, '2025-02-17', '', '00001'),
('20002', 68, '2025-02-17', '', '00001'),
('20002', 69, '2025-02-17', '', '00001'),
('20002', 70, '2025-02-17', '', '00001'),
('20002', 71, '2025-02-17', '', '00001'),
('20002', 72, '2025-02-17', '', '00001'),
('20002', 73, '2025-02-17', '', '00001'),
('20002', 74, '2025-02-17', '', '00001'),
('20002', 75, '2025-02-17', '', '00001'),
('20002', 76, '2025-02-17', '', '00001'),
('20002', 77, '2025-02-17', '', '00001'),
('20002', 78, '2025-02-17', '', '00001'),
('20002', 79, '2025-02-17', '', '00001'),
('20002', 80, '2025-02-17', '', '00001'),
('20002', 81, '2025-02-17', '', '00001'),
('20002', 82, '2025-02-17', '', '00001'),
('20002', 83, '2025-02-17', '', '00001'),
('20002', 84, '2025-02-17', '', '00001'),
('20002', 85, '2025-02-17', '', '00001'),
('20002', 86, '2025-02-17', '', '00001'),
('20002', 87, '2025-02-17', '', '00001'),
('20002', 88, '2025-02-17', '', '00001'),
('20002', 89, '2025-02-17', '', '00001'),
('20002', 90, '2025-02-17', '', '00001'),
('20002', 91, '2025-02-17', '', '00001'),
('20002', 92, '2025-02-17', '', '00001'),
('20002', 93, '2025-02-17', '', '00001'),
('20002', 94, '2025-02-17', '', '00001'),
('20002', 95, '2025-02-17', '', '00001'),
('20002', 96, '2025-02-17', '', '00001'),
('20002', 97, '2025-02-17', '', '00001'),
('20002', 98, '2025-02-17', '', '00001'),
('20002', 99, '2025-02-17', '', '00001'),
('20002', 100, '2025-02-17', '', '00001'),
('20002', 101, '2025-02-17', '', '00001'),
('20002', 102, '2025-02-17', '', '00001'),
('20002', 103, '2025-02-17', '', '00001'),
('20002', 104, '2025-02-17', '', '00001'),
('20002', 105, '2025-02-17', '', '00001'),
('20002', 106, '2025-02-17', '', '00001'),
('20002', 107, '2025-02-17', '', '00001'),
('20002', 108, '2025-02-17', '', '00001'),
('20002', 109, '2025-02-17', '', '00001'),
('20002', 110, '2025-02-17', '', '00001');

-- --------------------------------------------------------

--
-- Structure de la table `genre`
--

CREATE TABLE `genre` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `genre`
--

INSERT INTO `genre` (`id`, `libelle`) VALUES
('10000', 'Humour'),
('10001', 'Bande dessinée'),
('10002', 'Science Fiction'),
('10003', 'Biographie'),
('10004', 'Historique'),
('10006', 'Roman'),
('10007', 'Aventures'),
('10008', 'Essai'),
('10009', 'Documentaire'),
('10010', 'Technique'),
('10011', 'Voyages'),
('10012', 'Drame'),
('10013', 'Comédie'),
('10014', 'Policier'),
('10015', 'Presse Economique'),
('10016', 'Presse Culturelle'),
('10017', 'Presse sportive'),
('10018', 'Actualités'),
('10019', 'Fantazy');

-- --------------------------------------------------------

--
-- Structure de la table `livre`
--

CREATE TABLE `livre` (
  `id` varchar(10) NOT NULL,
  `ISBN` varchar(13) DEFAULT NULL,
  `auteur` varchar(20) DEFAULT NULL,
  `collection` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `livre`
--

INSERT INTO `livre` (`id`, `ISBN`, `auteur`, `collection`) VALUES
('00001', '1234569877896', 'Fred Vargas', 'Commissaire Adamsberg'),
('00002', '1236547896541', 'Dennis Lehanne', ''),
('00003', '6541236987410', 'Anne-Laure Bondoux', ''),
('00004', '3214569874123', 'Fred Vargas', 'Commissaire Adamsberg'),
('00005', '3214563214563', 'RJ Ellory', ''),
('00006', '3213213211232', 'Edgar P. Jacobs', 'Blake et Mortimer'),
('00007', '6541236987541', 'Kate Atkinson', ''),
('00008', '1236987456321', 'Jean d\'Ormesson', ''),
('00009', '', 'Fred Vargas', 'Commissaire Adamsberg'),
('00010', '', 'Manon Moreau', ''),
('00011', '', 'Victoria Hislop', ''),
('00012', '', 'Kate Atkinson', ''),
('00013', '', 'Raymond Briggs', ''),
('00014', '', 'RJ Ellory', ''),
('00015', '', 'Floriane Turmeau', ''),
('00016', '', 'Julian Press', ''),
('00017', '', 'Philippe Masson', ''),
('00018', '', '', 'Guide du Routard'),
('00019', '', '', 'Guide Vert'),
('00020', '', '', 'Guide Vert'),
('00021', '', 'Claudie Gallay', ''),
('00022', '', 'Claudie Gallay', ''),
('00023', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00024', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00025', '', 'Ayrolles - Masbou', 'De cape et de crocs'),
('00026', '', 'Pierre Boulle', 'Julliard');

-- --------------------------------------------------------

--
-- Structure de la table `livres_dvd`
--

CREATE TABLE `livres_dvd` (
  `id` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `livres_dvd`
--

INSERT INTO `livres_dvd` (`id`) VALUES
('00001'),
('00002'),
('00003'),
('00004'),
('00005'),
('00006'),
('00007'),
('00008'),
('00009'),
('00010'),
('00011'),
('00012'),
('00013'),
('00014'),
('00015'),
('00016'),
('00017'),
('00018'),
('00019'),
('00020'),
('00021'),
('00022'),
('00023'),
('00024'),
('00025'),
('00026'),
('20001'),
('20002'),
('20003'),
('20004');

-- --------------------------------------------------------

--
-- Structure de la table `public`
--

CREATE TABLE `public` (
  `id` varchar(5) NOT NULL,
  `libelle` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `public`
--

INSERT INTO `public` (`id`, `libelle`) VALUES
('00001', 'Jeunesse'),
('00002', 'Adultes'),
('00003', 'Tous publics'),
('00004', 'Ados');

-- --------------------------------------------------------

--
-- Structure de la table `rayon`
--

CREATE TABLE `rayon` (
  `id` char(5) NOT NULL,
  `libelle` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `rayon`
--

INSERT INTO `rayon` (`id`, `libelle`) VALUES
('BD001', 'BD Adultes'),
('BL001', 'Beaux Livres'),
('DF001', 'DVD films'),
('DV001', 'Sciences'),
('DV002', 'Maison'),
('DV003', 'Santé'),
('DV004', 'Littérature classique'),
('DV005', 'Voyages'),
('JN001', 'Jeunesse BD'),
('JN002', 'Jeunesse romans'),
('LV001', 'Littérature étrangère'),
('LV002', 'Littérature française'),
('LV003', 'Policiers français étrangers'),
('PR001', 'Presse quotidienne'),
('PR002', 'Magazines');

-- --------------------------------------------------------

--
-- Structure de la table `revue`
--

CREATE TABLE `revue` (
  `id` varchar(10) NOT NULL,
  `periodicite` varchar(2) DEFAULT NULL,
  `delaiMiseADispo` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `revue`
--

INSERT INTO `revue` (`id`, `periodicite`, `delaiMiseADispo`) VALUES
('10001', 'MS', 52),
('10002', 'MS', 52),
('10003', 'HB', 15),
('10004', 'HB', 15),
('10005', 'QT', 5),
('10006', 'QT', 5),
('10007', 'HB', 26),
('10008', 'HB', 26),
('10009', 'QT', 5),
('10010', 'HB', 12),
('10011', 'MS', 52);

-- --------------------------------------------------------

--
-- Structure de la table `service`
--

CREATE TABLE `service` (
  `id` int NOT NULL,
  `nom` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `service`
--

INSERT INTO `service` (`id`, `nom`) VALUES
(1, 'Service administratif'),
(2, 'Service prêts'),
(3, 'Service culture'),
(4, 'Service administrateurs');

-- --------------------------------------------------------

--
-- Structure de la table `suivi`
--

CREATE TABLE `suivi` (
  `id` int NOT NULL,
  `libelle` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `suivi`
--

INSERT INTO `suivi` (`id`, `libelle`) VALUES
(1, 'en cours'),
(2, 'réglée'),
(3, 'livrée'),
(4, 'relancée');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` int NOT NULL,
  `nom` varchar(32) NOT NULL,
  `prenom` varchar(32) NOT NULL,
  `login` varchar(255) NOT NULL,
  `pwd_hash` varchar(255) NOT NULL,
  `id_service` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `login`, `pwd_hash`, `id_service`) VALUES
(1, 'root', 'root', 'root', 'sX6W06xM2bhIQH+vLrzMQouNuZyZX1e3BDDlQmQr4P5xwuLwWopNe36l9Y4OmfoSNq/lElXQ6xO0EmzjMstGwAKSUXt8qf3aAPnAaRrFCDCchBkDQ0FxJ1YNhhyK1xVtXfE8Qdd4nozBgeKY8qvVjvlfXXddEJJyZiiGJ0aFPbg=', 4);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `abonnement`
--
ALTER TABLE `abonnement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idRevue` (`idRevue`);

--
-- Index pour la table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `commandedocument`
--
ALTER TABLE `commandedocument`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idLivreDvd` (`idLivreDvd`),
  ADD KEY `idSuivi` (`idSuivi`);

--
-- Index pour la table `document`
--
ALTER TABLE `document`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idRayon` (`idRayon`),
  ADD KEY `idPublic` (`idPublic`),
  ADD KEY `idGenre` (`idGenre`);

--
-- Index pour la table `dvd`
--
ALTER TABLE `dvd`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `etat`
--
ALTER TABLE `etat`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `exemplaire`
--
ALTER TABLE `exemplaire`
  ADD PRIMARY KEY (`id`,`numero`),
  ADD KEY `idEtat` (`idEtat`);

--
-- Index pour la table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `livre`
--
ALTER TABLE `livre`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `livres_dvd`
--
ALTER TABLE `livres_dvd`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `public`
--
ALTER TABLE `public`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `rayon`
--
ALTER TABLE `rayon`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `revue`
--
ALTER TABLE `revue`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `service`
--
ALTER TABLE `service`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `suivi`
--
ALTER TABLE `suivi`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unicite_login` (`login`),
  ADD KEY `id_service` (`id_service`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `service`
--
ALTER TABLE `service`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `suivi`
--
ALTER TABLE `suivi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `abonnement`
--
ALTER TABLE `abonnement`
  ADD CONSTRAINT `abonnement_ibfk_1` FOREIGN KEY (`id`) REFERENCES `commande` (`id`),
  ADD CONSTRAINT `abonnement_ibfk_2` FOREIGN KEY (`idRevue`) REFERENCES `revue` (`id`);

--
-- Contraintes pour la table `commandedocument`
--
ALTER TABLE `commandedocument`
  ADD CONSTRAINT `commandedocument_ibfk_1` FOREIGN KEY (`id`) REFERENCES `commande` (`id`),
  ADD CONSTRAINT `commandedocument_ibfk_2` FOREIGN KEY (`idLivreDvd`) REFERENCES `livres_dvd` (`id`),
  ADD CONSTRAINT `commandedocument_ibfk_3` FOREIGN KEY (`idSuivi`) REFERENCES `suivi` (`id`);

--
-- Contraintes pour la table `document`
--
ALTER TABLE `document`
  ADD CONSTRAINT `document_ibfk_1` FOREIGN KEY (`idRayon`) REFERENCES `rayon` (`id`),
  ADD CONSTRAINT `document_ibfk_2` FOREIGN KEY (`idPublic`) REFERENCES `public` (`id`),
  ADD CONSTRAINT `document_ibfk_3` FOREIGN KEY (`idGenre`) REFERENCES `genre` (`id`);

--
-- Contraintes pour la table `dvd`
--
ALTER TABLE `dvd`
  ADD CONSTRAINT `dvd_ibfk_1` FOREIGN KEY (`id`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `exemplaire`
--
ALTER TABLE `exemplaire`
  ADD CONSTRAINT `exemplaire_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`),
  ADD CONSTRAINT `exemplaire_ibfk_2` FOREIGN KEY (`idEtat`) REFERENCES `etat` (`id`);

--
-- Contraintes pour la table `livre`
--
ALTER TABLE `livre`
  ADD CONSTRAINT `livre_ibfk_1` FOREIGN KEY (`id`) REFERENCES `livres_dvd` (`id`);

--
-- Contraintes pour la table `livres_dvd`
--
ALTER TABLE `livres_dvd`
  ADD CONSTRAINT `livres_dvd_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`);

--
-- Contraintes pour la table `revue`
--
ALTER TABLE `revue`
  ADD CONSTRAINT `revue_ibfk_1` FOREIGN KEY (`id`) REFERENCES `document` (`id`);

--
-- Contraintes pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD CONSTRAINT `utilisateur_ibfk_1` FOREIGN KEY (`id_service`) REFERENCES `service` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
