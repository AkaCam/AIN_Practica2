import json
import random
import math
from loguru import logger
from spade.behaviour import OneShotBehaviour
from spade.template import Template
from spade.message import Message
from pygomas.agents.bditroop import BDITroop
from pygomas.agents.bdisoldier import BDISoldier 
from pygomas.agents.bdifieldop import BDIFieldOp
from agentspeak import Actions
from agentspeak import grounded
from agentspeak.stdlib import actions
from pygomas.ontology import Belief
import agentspeak as asp
from pygomas.ontology import Action, Belief, Performative, Service
from pygomas.config import MIN_AMMO
import numpy as np


from pygomas.agents.agent import LONG_RECEIVE_WAIT

class Soldier(BDITroop):
      
      def add_custom_actions(self, actions):
            super().add_custom_actions(actions)
      
            @actions.add_function(".safeToShoot", (tuple))
            def _safeToShoot(pos):
                  fov = self.fov_objects
                  aimed = self.aimed_agent
                  if len(fov) > 1:
                        allieds = []
                        allieds.extend([agent for agent in fov if agent.team == self.team])
                        if allieds:
                              ix = float(pos[0])
                              iz = float(pos[2])
                              ex = float(self.movement.position.x)
                              ez = float(self.movement.position.z)
                              for allied in allieds:
                                    ax = float(allied.position.x)
                                    az = float(allied.position.z)
                                    if self.is_between((ix, iz), (ex, ez), (ax, az)): return True
                        return True

            
            
            
            
      
                        
      # @actions.add_function(".closestMedic", (tuple, tuple))
      #   def _operativo_mas_cercano(pos_sol, pos_meds):
      #             '''
      #                   Elige el operativo más cercano.

      #                   pos_sol: Posicion de la unidad que solicita la ayuda.
      #                   posicion_agentes: La lista de las posiciones de los operativos.
                        
      #                   return: La posición del operativo más cercano.
      #             '''
      #             if len(self.medics_count) == 0: return []
      #             medico_cercano = None
      #             distancia_minima = float('inf')
                        
      #             for pos_med in pos_meds:
      #                   distancia_actual = math.sqrt((pos_sol[0] - pos_meds[0])**2 + (pos_sol[2] - pos_meds[2])**2)
      #                   if distancia_actual < distancia_minima:
      #                         distancia_minima = distancia_actual
      #                         medico_cercano = pos_med
                                    
      #             return medico_cercano


def is_between(self, a:tuple, b:tuple, c:tuple):
      """
            Verifica si el punto `b` está entre `a` y `c` en un plano bidimensional.
            
      a, b, c: listas o tuplas de dos elementos representando las coordenadas (x, y)
      """
      # Convertir los puntos a arrays de numpy
      a = np.array(a)
      b = np.array(b)
      c = np.array(c)
            
      # Vector desde a hasta b y desde a hasta c
      ab = b - a
      ac = c - a
            
      # Verificar si los puntos son colineales (el producto cruzado debe ser 0)
      cross_product = np.cross(ab, ac)
      if not np.isclose(cross_product, 0):
            return False
            
      # Verificar si la distancia ab + bc es igual a la distancia ac
      ab_length = np.linalg.norm(ab)
      bc_length = np.linalg.norm(c - b)
      ac_length = np.linalg.norm(ac)
      
      return np.isclose(ab_length + bc_length, ac_length)
